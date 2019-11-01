require 'pry'
require "curses"
include Curses

class HudBar
  def self.draw room_name
    attron(color_pair(HUDBAR_PAIR))
    setpos(0,0)
    line = ''
    cols.times.each{|i| line += ' '}
    addstr(line)
    setpos(0,2)
    addstr("Room: #{room_name}")
    attroff(color_pair(HUDBAR_PAIR))
  end
end
