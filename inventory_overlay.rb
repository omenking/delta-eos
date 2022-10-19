require 'pry'
require "curses"
include Curses

class InventoryOverlay
  def self.draw mode, inventory, inventory_database
    return unless mode == :inventory_overlay

    InventoryOverlay.draw_bg
    InventoryOverlay.draw_heading
    InventoryOverlay.draw_inventory inventory, inventory_database
  end
  
  def self.draw_bg
    # lines is a curses function for the number
    # of lines visible on the terminal
    # https://tldp.org/LDP/lpg/node97.html
    lines.times.each do |row|
      # draw top and bottom background striped bars
      if row < 3 || row > lines-4
        line = cols.times.map{|t|'╲'}.join('')
        Game.str row, 0, line
      else
        # cols is a curses function for vertical lines
        line = cols.times.map do |col|
          # draw left and right background striped bars
          if col < 6 || col > cols-6
            '╲'
          # draw left and right frame
          elsif [6,7,cols-6,cols-7].include?(col)
            '█'
          # draw top and bottom frame
          elsif row == 3 || row == lines-4
            '█'
          # draw heading divder
          elsif row == 7
            '▔'
          # everything else is blank
          else
            ' '
          end
        end.join('')
        # Draw the the line
        Game.str row, 0, line
      end # if
    end # lines.times.each do |row|
  end # def self.draw_bg

  def self.draw_heading
    Game.str 5, 11, 'Inventory'
    line = 'Exit [X]'
    Game.str 5, cols-9-line.length, line
  end # def self.draw_bg

  def self.draw_inventory inventory, inventory_database
    inventory.each_with_index do |obj_name,i|
      Game.str 8+i, 11, inventory_database[obj_name]['name']
    end
  end
end # class InventoryOverlay
