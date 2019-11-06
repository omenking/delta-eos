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
    Color.color :black_cyan do
      Game.str lines/2, (cols-Dialog.width)/2, 'P'
    end
  end
end
