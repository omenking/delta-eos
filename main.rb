require_relative 'hud_bar'
require_relative 'game_data'
require_relative 'color'
require_relative 'player'
require_relative 'render_walls'
require_relative 'room'
require_relative 'dialog'
require_relative 'skills_overlay'
require_relative 'inventory_overlay'
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
data.add_room :hall_beta,
              "#{Dir.pwd}/data/rooms/hall_beta.layout.txt",
              "#{Dir.pwd}/data/rooms/hall_beta.metadata.json"
data.add_room :hall_gamma,
              "#{Dir.pwd}/data/rooms/hall_gamma.layout.txt",
              "#{Dir.pwd}/data/rooms/hall_gamma.metadata.json"
data.add_room :holding_area,
              "#{Dir.pwd}/data/rooms/holding_area.layout.txt",
              "#{Dir.pwd}/data/rooms/holding_area.metadata.json"
data.add_room :security_office,
              "#{Dir.pwd}/data/rooms/security_office.layout.txt",
              "#{Dir.pwd}/data/rooms/security_office.metadata.json"
data.add_thread :decker_holding_cell,
              "#{Dir.pwd}/data/threads/decker_holding_cell.json"
data.add_room :foreman,
              "#{Dir.pwd}/data/rooms/foreman.layout.txt",
              "#{Dir.pwd}/data/rooms/foreman.metadata.json"

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
  if ch == '`'
    close_screen
    binding.pry
  end
  action = Game.action ch
  case data.mode
  when :inventory_overlay
    case action
    when :exit
      data.mode = :room
    end
  when :skills_overlay
    SkillsOverlay.action data, action
  when :dialog
    Dialog.action(data, action)
  when :room
    Room.actions(data, action)
    Room.check_neighbours(data)
    Room.update_room_states(data)
  end
  Game.draw data
  data.frame += 1
  data.frame  = 0 if data.frame == 7
end
