require 'pry'
require "curses"
include Curses

class Room
  # Return what action should occur
  def self.tile_data(x,y,data,objects)
    if data[y].nil? || data[y][x].nil?
      return { 'handle' => :void }
    end
    case data[y][x]
    when 'W'
      { 'handle' => :wall  }
    when ' '
      { 'handle' => :empty }
    else
      if objects.key?(data[y][x])
        objects[data[y][x]]
      else
        raise "object not found for tile: #{data[y][x]}"
      end
    end
  end

  def self.draw player_x, player_y, data
    rendered = RenderWalls.render data
    y = 0
    rendered.each do |row|
      setpos(
        (lines/ 2)+y-player_y,
        (cols / 2)-player_x
      )
      addstr(row)
      y += 1
    end
  end

end
