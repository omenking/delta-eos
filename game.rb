require 'pry'
require "curses"
include Curses


class Game
  def self.init
    timeout = 500
    init_screen
    curs_set(0) # hide cursor
    crmode
    Color.init
    refresh
  end

  def self.action ch
    case ch
    when 'h' then :left
    when 'j' then :down
    when 'k' then :up
    when 'l' then :right
    when 'f' then :enter
    when 'n' then :health
    when 'm' then :morale
    when 't' then :skills
    when 'i' then :inv
    when 'x' then :exit
    end
  end

  def self.str x, y, str, color=nil
    if color
      Color.color color.to_sym do
        setpos x, y
        addstr str
      end
    else
      setpos x, y
      addstr str
    end
  end

  def self.draw data
    clear
    Dialog.draw(
      data.mode,
      data.dialog_selected_index,
      data.strand,
      data.level,
      data.next_exp,
      data.prev_exp,
      data.exp,
      data.skills,
      data.health,
      data.morale
    )
    HudBar.draw(
      data.mode,
      data.room_name
    )
    Room.draw(
      data.player_x,
      data.player_y,
      data.room_layout,
      data.room_objects,
      data.frame
    )
    Player.draw(
      data.player_x,
      data.player_y
    )
    Overlay.draw(
      data.mode
    )
    refresh
  end
end
