require 'pry'
require "curses"
include Curses

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
