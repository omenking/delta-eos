require_relative 'hud_bar'
require_relative 'game_data'
require_relative 'player'
require_relative 'render_walls'
require_relative 'room'
require_relative 'dialog'
require_relative 'game'

# colours Foreground Background
WHITE_ON_BLACK = 0
BLACK_ON_WHITE = 1
BLACK_ON_GREEN = 2
GREEN_ON_BLACK = 3

data = GameData.new
data.add_room :hall,
              "#{Dir.pwd}/data/rooms/hall.layout.txt",
              "#{Dir.pwd}/data/rooms/hall.metadata.json"
data.add_room :holding_area,
              "#{Dir.pwd}/data/rooms/holding_area.layout.txt",
              "#{Dir.pwd}/data/rooms/holding_area.metadata.json"
data.add_room :security_office,
              "#{Dir.pwd}/data/rooms/security_office.layout.txt",
              "#{Dir.pwd}/data/rooms/security_office.metadata.json"
data.add_thread :decker_holding_cell,
              "#{Dir.pwd}/data/threads/decker_holding_cell.json"

def onsig(sig)
  close_screen
  exit sig
end

# main #
for i in %w[HUP INT QUIT TERM]
  if trap(i, "SIG_IGN") != 0 then  # 0 for SIG_IGN
    trap(i) {|sig| onsig(sig) }
  end
end

Game.init
Game.draw data
while true
  # -----------------------------------------
  ch = getch

  action =
  case ch
  when 'h' then :left
  when 'j' then :down
  when 'k' then :up
  when 'l' then :right
  when 'f' then :enter
  end

  x     = data.player_x
  y     = data.player_y
  new_x = data.player_x
  new_y = data.player_y


  case data.mode
    when :dialog
      case action
      when :up
        data.dialog_selected_index = Dialog.up data.dialog_selected_index, data.strand
      when :down
        data.dialog_selected_index = Dialog.down data.dialog_selected_index, data.strand
      when :enter
        result = data.strand_result
        data.mode = :room         if result['leave']
        data.exp += result['exp'] if result['exp']
      end
    when :room
      case action
      when :up    then new_y = Player.up    y
      when :down  then new_y = Player.down  y
      when :left  then new_x = Player.left  x
      when :right then new_x = Player.right x
      end

      current_tile = Room.tile_data x    , y    , data.room_layout, data.room_objects
      future_tile  = Room.tile_data new_x, new_y, data.room_layout, data.room_objects

      case current_tile['handle'].to_sym
      when :door
        if current_tile['exit_action'].to_sym == action
          data.player_room = current_tile['exit_room'].to_sym
          data.player_y    = current_tile['exit_position']['y']
          data.player_x    = current_tile['exit_position']['x']
        else
          case future_tile['handle'].to_sym
          when :empty
            data.player_y = new_y
            data.player_x = new_x
          end
        end
      else
        case future_tile['handle'].to_sym
        when :force_field_decker
          data.dialog_selected_index = 0
          data.thread = :decker_holding_cell
          data.mode   = :dialog
        when :door
          data.player_y = new_y
          data.player_x = new_x
        when :empty
          data.player_y = new_y
          data.player_x = new_x
        end
      end
  end
  Game.draw data
  sleep(0.05)
end
