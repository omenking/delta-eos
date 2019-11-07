require 'pry'
require "curses"
include Curses

class SkillsOverlay
  def self.draw mode, selected
    return unless mode == :skills_overlay
    lines.times.each do |row|
      if row < 3 || row > lines-4
        line = cols.times.map{|t|'╳'}.join('')
        Game.str row, 0, line
      else
        line = cols.times.map do |col|
          if col < 6 || col > cols-6
            '╳'
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
        Game.str row, 0, line
      end
      Game.str 5, 11, 'Skills'
      line = 'Exit [X]'
      Game.str 5, cols-9-line.length, line

      self.draw_box 8      , 10                , 'Enthusiam' ,(selected == 0 ? :magenta_black : :white_black)
      self.draw_box 8      , 10+((cols-17)/4)*1, 'Logic'     ,(selected == 1 ? :magenta_black : :white_black)
      self.draw_box 8      , 10+((cols-17)/4)*2, 'Knowledge' ,(selected == 2 ? :magenta_black : :white_black)
      self.draw_box 8      , 10+((cols-17)/4)*3, 'Hacking'   ,(selected == 3 ? :magenta_black : :white_black)
      self.draw_box 8+9    , 10                , 'Endurance' ,(selected == 4 ? :magenta_black : :white_black)
      self.draw_box 8+9    , 10+((cols-17)/4)*1, 'Muscle'    ,(selected == 5 ? :magenta_black : :white_black)
      self.draw_box 8+9    , 10+((cols-17)/4)*2, 'Authority' ,(selected == 6 ? :magenta_black : :white_black)
      self.draw_box 8+9    , 10+((cols-17)/4)*3, 'Luck'      ,(selected == 7 ? :magenta_black : :white_black)
      self.draw_box 8+(9*2), 10                , 'Acting'    ,(selected == 8 ? :magenta_black : :white_black)
      self.draw_box 8+(9*2), 10+((cols-17)/4)*1, 'Hunches'   ,(selected == 9 ? :magenta_black : :white_black)
      self.draw_box 8+(9*2), 10+((cols-17)/4)*2, 'Perception',(selected == 10 ? :magenta_black : :white_black)
      self.draw_box 8+(9*2), 10+((cols-17)/4)*3, 'Mysticsm'  ,(selected == 11 ? :magenta_black : :white_black)
    end
  end

  def self.draw_box row, col, title, color
    width = (cols-17)/4
    Color.color color do
      line = '┏' + (width-2).times.map{|t|'╾'}.join('') + '┓'
      Game.str row, col, line


      8.times.each do |i|
        line = '┃' + (width-2).times.map{|t|'█'}.join('') + '┃'
        Game.str row+i+1, col, line
      end

      line = '┗' + (width-2).times.map{|t|'╾'}.join('') + '┛'
      Game.str row+8, col, line
    end
    n = color.to_s.split('_')
    color_alt = "#{n[1]}_#{n[0]}".to_sym
    Game.str row+2, col+2 , title, color_alt
    #Color.color color_alt do
      #Game.str row+1, col+width-11,' ▗▆▆▆  '
      #Game.str row+2, col+width-11,'▟████  '
      #Game.str row+3, col+width-11,'▔▔███  '
      #Game.str row+4, col+width-11,'  ███  '
      #Game.str row+5, col+width-11,'  ███  '
      #Game.str row+6, col+width-11,'███████'
      #Game.str row+7, col+width-11,'▀▀▀▀▀▀▀'
    #end
    Color.color color_alt do
      Game.str row+1, col+width-11,' ▗▆▆▆▄ '
      Game.str row+2, col+width-11,'▟█████▌'
      Game.str row+3, col+width-11,'▔▔ ███ '
      Game.str row+4, col+width-11,'  ███▘ '
      Game.str row+5, col+width-11,'▗██▘   '
      Game.str row+6, col+width-11,'███████'
      Game.str row+7, col+width-11,'▀▀▀▀▀▀▀'
    end
  end

  def self.action data, action
    case action
    when :up
      data.skill_selected_index -= 4
    when :down
      data.skill_selected_index += 4
    when :left
      data.skill_selected_index -= 1
    when :right
      data.skill_selected_index += 1
    when :enter
    when :exit
      data.mode = :room
    end
    if data.skill_selected_index > 11
      data.skill_selected_index -= 12
    elsif  data.skill_selected_index < 0
      data.skill_selected_index += 12
    end
  end
end
