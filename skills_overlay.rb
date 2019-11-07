require 'pry'
require "curses"
include Curses

class SkillsOverlay
  def self.draw mode, selected, skills, level, points_used
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
    end
    Game.str 5, 11, 'Skills'
    line = 'Exit [X]'
    Game.str 5, cols-9-line.length, line

    Game.str 8, 11, 'Brains'
    c = level - points_used > 0 ? :magenta_black : :cyan_black
    self.draw_box 9 , 10                , 'Enthusiam' , skills[:enthusiasm],(selected == 0 ? c : :white_black)
    self.draw_box 9 , 10+((cols-17)/4)*1, 'Logic'     , skills[:logic]     ,(selected == 1 ? c : :white_black)
    self.draw_box 9 , 10+((cols-17)/4)*2, 'Knowledge' , skills[:knowledge] ,(selected == 2 ? c : :white_black)
    self.draw_box 9 , 10+((cols-17)/4)*3, 'Hacking'   , skills[:hacking]   ,(selected == 3 ? c : :white_black)

    Game.str      19, 11, 'Brawns'
    self.draw_box 20 , 10                , 'Endurance' , skills[:endurance] ,(selected == 4 ? c : :white_black)
    self.draw_box 20 , 10+((cols-17)/4)*1, 'Reaction'  , skills[:reaction]  ,(selected == 5 ? c : :white_black)
    self.draw_box 20 , 10+((cols-17)/4)*2, 'Muscle'    , skills[:muscle]    ,(selected == 6 ? c : :white_black)
    self.draw_box 20 , 10+((cols-17)/4)*3, 'Authority' , skills[:authority] ,(selected == 7 ? c : :white_black)

    Game.str      30, 11, 'Luck'
    self.draw_box 31, 10                , 'Acting'    , skills[:acting]    ,(selected == 8  ? c : :white_black)
    self.draw_box 31, 10+((cols-17)/4)*1, 'Hunches'   , skills[:hunches]   ,(selected == 9  ? c : :white_black)
    self.draw_box 31, 10+((cols-17)/4)*2, 'Perception', skills[:perception],(selected == 10 ? c : :white_black)
    self.draw_box 31, 10+((cols-17)/4)*3, 'Mysticsm'  , skills[:mysticsm]  ,(selected == 11 ? c : :white_black)
    if (level - points_used) > 0
      line = "▖ #{level - points_used} Points Avaliable ▝"
      Game.str 5, 20, line, :black_magenta
    end
  end

  def self.draw_box row, col, title, skill, color
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
    case skill
    when 0
      Color.color color_alt do
        Game.str row+1, col+width-11,'▗▆▆▆▆▆▖'
        Game.str row+2, col+width-11,'███████'
        Game.str row+3, col+width-11,'██▘ ▝██'
        Game.str row+4, col+width-11,'██   ██'
        Game.str row+5, col+width-11,'██▖ ▗██'
        Game.str row+6, col+width-11,'███████'
        Game.str row+7, col+width-11,'▝▀▀▀▀▀▘'
      end
    when 1
      Color.color color_alt do
        Game.str row+1, col+width-11,' ▗▆▆▆  '
        Game.str row+2, col+width-11,'▟████  '
        Game.str row+3, col+width-11,'▔▔███  '
        Game.str row+4, col+width-11,'  ███  '
        Game.str row+5, col+width-11,'  ███  '
        Game.str row+6, col+width-11,'███████'
        Game.str row+7, col+width-11,'▀▀▀▀▀▀▀'
      end
    when 2
      Color.color color_alt do
        Game.str row+1, col+width-11,' ▗▆▆▆▄ '
        Game.str row+2, col+width-11,'▟█████▌'
        Game.str row+3, col+width-11,'▔▔ ███ '
        Game.str row+4, col+width-11,'  ███▘ '
        Game.str row+5, col+width-11,'▗██▘   '
        Game.str row+6, col+width-11,'███████'
        Game.str row+7, col+width-11,'▀▀▀▀▀▀▀'
      end
    when 3
      Color.color color_alt do
        Game.str row+1, col+width-11,' ▗▆▆▆▄ '
        Game.str row+2, col+width-11,'▟█████▌'
        Game.str row+3, col+width-11,'▔▔ ███ '
        Game.str row+4, col+width-11,'  ███▘ '
        Game.str row+5, col+width-11,'▄▄ ██▙ '
        Game.str row+6, col+width-11,'▜█████▌'
        Game.str row+7, col+width-11,' ▀▀▀▀▀ '
      end
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
      if (data.level - data.points_used) > 0
        data.points_used += 1
        case data.skill_selected_index
        when 0  then data.skills[:enthusiasm] += 1
        when 1  then data.skills[:logic]      += 1
        when 2  then data.skills[:knowledge]  += 1
        when 3  then data.skills[:hacking]    += 1
        when 4  then data.skills[:endurance]  += 1
        when 5  then data.skills[:reaction]   += 1
        when 6  then data.skills[:muscle]     += 1
        when 7  then data.skills[:authority]  += 1
        when 8  then data.skills[:acting]     += 1
        when 9  then data.skills[:hunches]    += 1
        when 10 then data.skills[:perception] += 1
        when 11 then data.skills[:mysticsm]   += 1
        end
      end
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
