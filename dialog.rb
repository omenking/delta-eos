require 'pry'
require "curses"
include Curses
class Dialog
  def self.width
    60
  end

  def self.draw mode, dialog_selected_index, strand, level, next_exp, prev_exp, exp, skills, health, morale
    lines.times.each do |row|
      line = ''
      setpos(row,cols-self.width)

      attron(color_pair(GREEN_ON_BLACK)) if mode == :dialog
      addstr('│')
      attroff(color_pair(GREEN_ON_BLACK)) if mode == :dialog
      #attron(color_pair(BLACK_ON_GREEN))
      #data = File.read "#{Dir.pwd}/data/character.txt"
      #data.split("\n").each_with_index do |str,i|
        #setpos(i+2,cols-column_length)
        #addstr(str)
      #end
      #attroff(color_pair(BLACK_ON_GREEN))
    end

    case mode
    when :dialog
      self.draw_choices dialog_selected_index, strand
    when :room
      self.draw_stats level, next_exp, prev_exp, exp, skills, health, morale
    end
  end

  def self.draw_stats level, next_exp, prev_exp, exp, skills, health, morale
    #health[:current]

    #morale[:current]
    #morale[:max]

    count = (40 - (health[:max]-1))/health[:max]
    line = health[:max].times.map{|t| health[:current] > t ? count.times.map{|tt|'█'}.join('') : count.times.map{|tt|'╳'}.join('') }.join(' ')
    Game.str 1,cols-self.width+2,"Health  #{line}"
    if health[:stock] > 0
      line = "[N] (#{health[:stock]})"
      Game.str 1,cols-line.size, line
    end
    count = (40 - (morale[:max]-1))/morale[:max]
    line = morale[:max].times.map{|t| morale[:current] > t ? count.times.map{|tt|'█'}.join('') : count.times.map{|tt|'╳'}.join('') }.join(' ')
    Game.str 3,cols-self.width+2,"Morale  #{line}"
    if morale[:stock] > 0
      line = "[M] (#{morale[:stock]})"
      Game.str 3,cols-line.size, line
    end

    #divider
    line = '├'
    (self.width-1).times.each{line << '─' }
    Game.str 5, cols-self.width, line

    Game.str 6,cols-self.width+2,"Experience (#{exp} / #{next_exp} XP)"
    line = "Level #{level}"
    Game.str 6,cols-line.length-1, line

    Game.str 8,cols-self.width+2, "╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾╾▏"
    per   = ((100.0 / next_exp) * (exp-prev_exp))/100
    count = (57.0*per).floor

    line = ''
    count.times.each{|t|line << '█'}
    Game.str 8,cols-self.width+2, line

    #divider
    line = '├'
    (self.width-1).times.each{line << '─' }
    Game.str 10, cols-self.width, line

    row = 11
    col = cols-self.width+2
    Game.str row, col, 'Skills [T]'         ; row += 2
    Game.str row, col, "  Brains (#{skills[:brains]})"   ; row += 1
    Game.str row, col, "  ├ Enthusiasm #{self.skill_points_draw(skills[:brains] + skills[:enthusiasm])}" ; row += 1
    Game.str row, col, "  ├ Logic      #{self.skill_points_draw(skills[:brains] + skills[:logic])}" ; row += 1
    Game.str row, col, "  ├ Knowledge  #{self.skill_points_draw(skills[:brains] + skills[:knowledge])}" ; row += 1
    Game.str row, col, "  └ Hacking    #{self.skill_points_draw(skills[:brains] + skills[:hacking])}" ; row += 2
    Game.str row, col, "  Brawns (#{skills[:brawns]})"  ; row += 1
    Game.str row, col, "  ├ Endurance  #{self.skill_points_draw(skills[:brawns] + skills[:endurance])}" ; row += 1
    Game.str row, col, "  ├ Reaction   #{self.skill_points_draw(skills[:brawns] + skills[:reaction])}" ; row += 1
    Game.str row, col, "  ├ Muscle     #{self.skill_points_draw(skills[:brawns] + skills[:muscle])}" ; row += 1
    Game.str row, col, "  └ Authority  #{self.skill_points_draw(skills[:brawns] + skills[:authority])}" ; row += 2
    Game.str row, col, "  Luck (#{skills[:luck]})"    ; row += 1
    Game.str row, col, "  ├ Acting     #{self.skill_points_draw(skills[:luck] + skills[:acting])}" ; row += 1
    Game.str row, col, "  ├ Hunches    #{self.skill_points_draw(skills[:luck] + skills[:hunches])}" ; row += 1
    Game.str row, col, "  ├ Perception #{self.skill_points_draw(skills[:luck] + skills[:perception])}" ; row += 1
    Game.str row, col, "  └ Mysticsm   #{self.skill_points_draw(skills[:luck] + skills[:mysticsm])}" ; row += 2

    #divider
    line = '├'
    (self.width-1).times.each{line << '─' }
    Game.str row, cols-self.width, line

    row += 1

    Game.str row, col, 'Inventory [I]'; row += 2
    Game.str row, col, '  Head       (none)'; row += 1
    Game.str row, col, '  Chest      (none)'; row += 1
    Game.str row, col, '  Legs       (none)'; row += 1
    Game.str row, col, '  Left-hand  (none)'; row += 1
    Game.str row, col, '  Right-hand (none)'; row += 1
    Game.str row, col, '  Feet       (none)'; row += 1
  end

  def self.skill_points_draw points
    line = 20.times.map{|t| points > t ? '◆' : '-' }
    line.join(' ')
  end

  def self.draw_choices dialog_selected_index, strand
    max_lines = 0
    choice_parts = []
    strand['choices'].each_with_index do |choice,i|
      text = "#{i+1}). " + choice['text']
      parts = text.scan(/.{1,#{self.width-4}}/)
      choice_parts << parts
      max_lines += parts.length
    end

    choice_parts.each{|cc|cc.each{|c| max_lines += 1}}

    current_line = 0
    choice_parts.each_with_index do |choice,choice_index|
      choice.each do |choice_part|
        setpos(lines-(max_lines-current_line+2),cols-self.width+2)
        attron(color_pair(BLACK_ON_GREEN)) if dialog_selected_index == choice_index
        addstr(choice_part)
        attroff(color_pair(BLACK_ON_GREEN)) if dialog_selected_index == choice_index
        current_line += 1
      end
    end

  end

  def self.enter strand, dialog_selected_index
    strand['choices'][dialog_selected_index]['results']
  end

  def self.up dialog_selected_index, strand
    if dialog_selected_index == 0
      strand['choices'].length-1
    else
      dialog_selected_index - 1
    end
  end

  def self.down dialog_selected_index, strand
    if dialog_selected_index == strand['choices'].length-1
      0
    else
      dialog_selected_index + 1
    end
  end
end
