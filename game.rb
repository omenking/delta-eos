require 'pry'
require "curses"
include Curses


class Game
  def self.init
    init_screen
    curs_set(0) # hide cursor
    crmode
    start_color
    init_pair(WHITE_ON_BLACK, COLOR_WHITE, COLOR_BLACK)
    init_pair(BLACK_ON_WHITE, COLOR_BLACK, COLOR_WHITE)
    init_pair(BLACK_ON_GREEN, COLOR_BLACK, COLOR_GREEN)
    init_pair(GREEN_ON_BLACK, COLOR_GREEN, COLOR_BLACK)
    use_default_colors
    refresh
  end

  def self.str x, y, str, color=nil
    setpos x, y
    addstr str
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
      data.exp
    )
    HudBar.draw(
      data.mode,
      data.room_name
    )
    Room.draw(
      data.player_x,
      data.player_y,
      data.room_layout,
      data.room_objects
    )
    Player.draw(
      data.player_x,
      data.player_y
    )
    refresh
  end
end
