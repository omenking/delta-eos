require_relative 'hud_bar'
require_relative 'game_data'
require_relative 'player'
require_relative 'render_walls'
require_relative 'room'
require_relative 'game'

# colours
SELECTED_PAIR = 1
HUDBAR_PAIR = 2

data = GameData.new
data.add_room :hall,
              "#{Dir.pwd}/data/hall.layout.txt",
              "#{Dir.pwd}/data/hall.metadata.json"
data.add_room :holding_area,
              "#{Dir.pwd}/data/holding_area.layout.txt",
              "#{Dir.pwd}/data/holding_area.metadata.json"
data.add_room :security_office,
              "#{Dir.pwd}/data/security_office.layout.txt",
              "#{Dir.pwd}/data/security_office.metadata.json"

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
  end

  x     = data.player_x
  y     = data.player_y
  new_x = data.player_x
  new_y = data.player_y

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
      when :door
        data.player_y = new_y
        data.player_x = new_x
      when :empty
        data.player_y = new_y
        data.player_x = new_x
      end
  end

  Game.draw data
  sleep(0.05)
end
