require 'pry'
require "curses"
include Curses

class InventoryOverlay
  def self.draw mode
    return unless mode == :inventory_overlay

    # lines is a curses function for the number
    # of lines visible on the terminal
    # https://tldp.org/LDP/lpg/node97.html
    lines.times.each do |row|
      if row < 3 || row > lines-4
        line = cols.times.map{|t|'╲'}.join('')
        Game.str row, 0, line
      else
        line = cols.times.map do |col|
          if col < 6 || col > cols-6
            '╲'
          elsif [6,7,cols-6,cols-7].include?(col)
            '█'
          elsif row == 3 || row == lines-4
            '█'
          elsif row == 7
            '▔'
          else
            ' '
          end
        end.join('')
        # Draw the background and frame
        Game.str row, 0, line
      end

      # Draw the heading 
      Game.str 5, 11, 'Inventory'
      line = 'Exit [X]'
      Game.str 5, cols-9-line.length, line
    end
  end
end

