require 'pry'
require "curses"
include Curses

class Dialog
  def self.width
    40
  end

  def self.draw mode, dialog_selected_index, choices
    lines.times.each do |row|
      line = ''
      setpos(row,cols-self.width)

      attron(color_pair(GREEN_ON_BLACK)) if mode == :dialog
      addstr('╽')
      attroff(color_pair(GREEN_ON_BLACK)) if mode == :dialog
      #attron(color_pair(BLACK_ON_GREEN))
      #data = File.read "#{Dir.pwd}/data/character.txt"
      #data.split("\n").each_with_index do |str,i|
        #setpos(i+2,cols-column_length)
        #addstr(str)
      #end
      #attroff(color_pair(BLACK_ON_GREEN))

    end

    return unless mode == :dialog
    max_lines = 0
    choice_parts = []
    choices.each_with_index do |choice,i|
      text = "#{i+1}). " + choice[:text]
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

  def self.up dialog_selected_index, choices
    if dialog_selected_index == 0
      choices.length-1
    else
      dialog_selected_index - 1
    end
  end

  def self.down dialog_selected_index, choices
    if dialog_selected_index == choices.length-1
      0
    else
      dialog_selected_index + 1
    end
  end
end
