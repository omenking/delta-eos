require 'pry'
require "curses"
include Curses

class HudBar
  def self.draw mode, room_name
    color, color_alt =
    if mode == :room
      [
        GREEN_ON_BLACK,
        BLACK_ON_GREEN
      ]
    else
      [
        WHITE_ON_BLACK,
        BLACK_ON_WHITE
      ]
    end
    attron(color_pair(color))
    # sold line
    line = ''
    (cols-Dialog.width).times.each{|i| line += '▄'}
    setpos(0,0)
    addstr(line)
    attroff(color_pair(color))
    attron(color_pair(color_alt))
    #solid
    line = ''
    (cols-Dialog.width).times.each{|i| line += ' '}
    setpos(1,0)
    addstr(line)
    # partial line
    line = ''
    (cols-Dialog.width).times.each{|i| line += '▄'}
    setpos(2,0)
    addstr(line)
    # text
    setpos(1,2)
    addstr("Room: #{room_name}")
    attroff(color_pair(color_alt))
  end
end
