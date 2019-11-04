require 'pry'
require "curses"
include Curses
class Dialog
  def self.width
    60
  end

  def self.draw mode, dialog_selected_index, strand, level, next_exp, prev_exp, exp
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
      self.draw_stats level, next_exp, prev_exp, exp
    end
  end

  def self.draw_stats level, next_exp, prev_exp, exp
    Game.str 1,cols-self.width+2,'Health    █████████ █████████ █████████ █████████ [N] (3)'
    Game.str 3,cols-self.width+2,'Morale    ███████████████████ ╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳╳ [M] (2)'

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
    Game.str row, col, '  Brains (3)'   ; row += 1
    Game.str row, col, '  ├ Enthusiasm ◆ ◆ - - - - - - - - - -' ; row += 1
    Game.str row, col, '  ├ Logic      ◆ ◆ - - - - - - - - - -' ; row += 1
    Game.str row, col, '  ├ Knowledge  ◆ ◆ - - - - - - - - - -' ; row += 1
    Game.str row, col, '  └ Hacking    ◆ ◆ - - - - - - - - - -' ; row += 2
    Game.str row, col, '  Brawns (2)'  ; row += 1
    Game.str row, col, '  ├ Endurance  ◆ ◆ - - - - - - - - - -' ; row += 1
    Game.str row, col, '  ├ Reaction   ◆ ◆ - - - - - - - - - -' ; row += 1
    Game.str row, col, '  ├ Muscle     ◆ ◆ - - - - - - - - - -' ; row += 1
    Game.str row, col, '  └ Authority  ◆ ◆ - - - - - - - - - -' ; row += 2
    Game.str row, col, '  Luck (4)'    ; row += 1
    Game.str row, col, '  ├ Acting     ◆ ◆ - - - - - - - - - -' ; row += 1
    Game.str row, col, '  ├ Hunches    ◆ ◆ - - - - - - - - - -' ; row += 1
    Game.str row, col, '  ├ Perception ◆ ◆ - - - - - - - - - -' ; row += 1
    Game.str row, col, '  └ Mysticsm   ◆ ◆ - - - - - - - - - -' ; row += 2

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
