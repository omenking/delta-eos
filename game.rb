require "curses"
include Curses

# colours
SELECTED_PAIR = 1
HUDBAR_PAIR = 2


class Player
  def self.up y
    y-1
  end

  def self.down y
    y+1
  end

  def self.left x
    x-1
  end

  def self.right x
    x+1
  end

  def self.draw x, y
    attron(color_pair(SELECTED_PAIR))
    setpos(lines/2,cols/2)
    addch('P')
    attroff(color_pair(SELECTED_PAIR))
  end
end

class Room
  def self.draw player_x, player_y, data
    y = 0
    data.split("\n").each do |row|
      setpos(
        (lines/ 2)+y-player_y,
        (cols / 2)-player_x
      )
      addstr(row)
      y += 1
    end
  end
end

class HudBar
  def self.draw
    attron(color_pair(HUDBAR_PAIR))
    setpos(0,0)
    line = ''
    cols.times.each{|i| line += ' '}
    addstr(line)
    setpos(0,2)
    addstr('Room: Security Holding Area')
    attroff(color_pair(HUDBAR_PAIR))
  end
end

class Game
  def self.init
    init_screen
    curs_set(0) # hide cursor
    crmode
    start_color
    init_pair(SELECTED_PAIR, COLOR_BLACK, COLOR_WHITE)
    init_pair(HUDBAR_PAIR  , COLOR_BLACK, COLOR_GREEN)
    use_default_colors
    refresh
  end

  def self.draw data
    clear
    HudBar.draw
    Room.draw(
      data[:player][:position][:x],
      data[:player][:position][:y],
      data[:rooms][:hall][:data]
    )
    Player.draw(
      data[:player][:position][:x],
      data[:player][:position][:y]
    )
    refresh
  end
end

data = {
  running: true,
  player: {
    position: {
      room: 'hall',
      x: 5,
      y: 5
    }
  },
  rooms: {
    hall: {
      data: File.read('rooms/hall.txt'),
      position: {
        x: 0,
        y: 1
      }
    }
  }
}

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
  case ch
    when 'h' # left
      x = Player.left data[:player][:position][:x]
      data[:player][:position][:x] = x
    when 'j' # down
      y = Player.down data[:player][:position][:y]
      data[:player][:position][:y] = y
    when 'k' # up
      y = Player.up data[:player][:position][:y]
      data[:player][:position][:y] = y
    when 'l' # right
      x = Player.right data[:player][:position][:x]
      data[:player][:position][:x] = x
  end
  Game.draw data
  sleep(0.05)
end
