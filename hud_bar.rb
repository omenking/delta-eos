require 'pry'
require "curses"
include Curses

class HudBar
  def self.draw mode, room_name
    color, color_alt =
    if mode == :room
      [
        :green_black,
        :black_green
      ]
    else
      [
        :white_black,
        :black_white
      ]
    end
    Color.color color do
      Game.str 0, 0, (cols-Dialog.width).times.map{|i|'▄'}.join('')
    end

    Color.color color_alt do
      Game.str 1, 0, (cols-Dialog.width).times.map{|i|' '}.join('')
      Game.str 2, 0, (cols-Dialog.width).times.map{|i|'▄'}.join('')
      Game.str 1, 2, "Room: #{room_name}"
    end
  end
end
