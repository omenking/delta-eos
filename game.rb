require 'pry'
require "curses"
include Curses


class Game
  def self.init
    init_screen
    curs_set(0) # hide cursor
    crmode
    start_color
    init_pair(SELECTED_PAIR, COLOR_BLACK, COLOR_WHITE)
    init_pair(HUDBAR_PAIR  , COLOR_BLACK, COLOR_GREEN)
    use_default_colors
    refresh
  end

  def self.draw data
    clear
    HudBar.draw(
      data.room_name
    )
    Room.draw(
      data.player_x,
      data.player_y,
      data.room_layout
    )
    Player.draw(
      data.player_x,
      data.player_y
    )
    refresh
  end
end
