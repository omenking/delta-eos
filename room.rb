require 'pry'
require "curses"
include Curses

class Room
  # Return what action should occur
  def self.tile_data(x,y,data,objects)
    if data[y].nil? || data[y][x].nil?
      return { 'handle' => :void }
    end
    if data[y][x] == 'W'
      { 'handle' => :wall  }
    else
      object =
      objects.find do |obj|
        obj['position']['x'] == x &&
        obj['position']['y'] == y
      end
      if object
        object
      else
        { 'handle' => :empty }
      end
    end
  end

  def self.draw player_x, player_y, layout, objects
    rendered = RenderWalls.render layout
    y = 0
    rendered.each do |row|
      setpos(
        (lines/ 2)+y-player_y,
        ((cols-Dialog.width) / 2)-player_x
      )
      addstr(row)
      y += 1
    end
    #close_screen
    #binding.pry
    objects.each do |obj|
      setpos(
        obj['position']['y']+((lines/ 2)-player_y),
        obj['position']['x']+(((cols-Dialog.width) / 2)-player_x)
      )
      attron(color_pair(BLACK_ON_WHITE))
      addstr(obj['character'])
      attroff(color_pair(BLACK_ON_WHITE))
    end
  end

end
