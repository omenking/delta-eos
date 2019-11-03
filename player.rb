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
    attron(color_pair(BLACK_ON_WHITE))
    setpos(lines/2,(cols-Dialog.width)/2)
    addch('P')
    attroff(color_pair(BLACK_ON_WHITE))
  end
end
