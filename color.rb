require 'pry'
require "curses"
include Curses

class Color
  def self.colors
    {
      :black_red       => { index: 0, pair: [COLOR_BLACK,COLOR_RED] },
      :black_green     => { index: 1, pair: [COLOR_BLACK,COLOR_GREEN] },
      :black_yellow    => { index: 2, pair: [COLOR_BLACK,COLOR_YELLOW] },
      :black_blue      => { index: 3, pair: [COLOR_BLACK,COLOR_BLUE] },
      :black_magenta   => { index: 4, pair: [COLOR_BLACK,COLOR_MAGENTA] },
      :black_cyan      => { index: 5, pair: [COLOR_BLACK,COLOR_CYAN] },
      :black_white     => { index: 6, pair: [COLOR_BLACK,COLOR_WHITE] },

      :red_black       => { index: 7, pair: [COLOR_RED,COLOR_BLACK] },
      :red_green       => { index: 8, pair: [COLOR_RED,COLOR_GREEN] },
      :red_yellow      => { index: 9, pair: [COLOR_RED,COLOR_YELLOW] },
      :red_blue        => { index: 10, pair: [COLOR_RED,COLOR_BLUE] },
      :red_magenta     => { index: 11, pair: [COLOR_RED,COLOR_MAGENTA] },
      :red_cyan        => { index: 12, pair: [COLOR_RED,COLOR_CYAN] },
      :red_white       => { index: 13, pair: [COLOR_RED,COLOR_WHITE] },

      :green_black     => { index: 14, pair: [COLOR_GREEN,COLOR_BLACK] },
      :green_red       => { index: 15, pair: [COLOR_GREEN,COLOR_RED] },
      :green_yellow    => { index: 16, pair: [COLOR_GREEN,COLOR_YELLOW] },
      :green_blue      => { index: 17, pair: [COLOR_GREEN,COLOR_BLUE] },
      :green_magenta   => { index: 18, pair: [COLOR_GREEN,COLOR_MAGENTA] },
      :green_cyan      => { index: 19, pair: [COLOR_GREEN,COLOR_CYAN] },
      :green_white     => { index: 20, pair: [COLOR_GREEN,COLOR_WHITE] },

      :yellow_black    => { index: 21, pair: [COLOR_YELLOW,COLOR_BLACK] },
      :yellow_red      => { index: 22, pair: [COLOR_YELLOW,COLOR_RED] },
      :yellow_green    => { index: 23, pair: [COLOR_YELLOW,COLOR_GREEN] },
      :yellow_blue     => { index: 24, pair: [COLOR_YELLOW,COLOR_BLUE] },
      :yellow_magenta  => { index: 25, pair: [COLOR_YELLOW,COLOR_MAGENTA] },
      :yellow_cyan     => { index: 26, pair: [COLOR_YELLOW,COLOR_CYAN] },
      :yellow_white    => { index: 27, pair: [COLOR_YELLOW,COLOR_WHITE] },

      :blue_black      => { index: 28, pair: [COLOR_BLUE,COLOR_BLACK] },
      :blue_red        => { index: 29, pair: [COLOR_BLUE,COLOR_RED] },
      :blue_green      => { index: 30, pair: [COLOR_BLUE,COLOR_GREEN] },
      :blue_yellow     => { index: 31, pair: [COLOR_BLUE,COLOR_YELLOW] },
      :blue_magenta    => { index: 32, pair: [COLOR_BLUE,COLOR_MAGENTA] },
      :blue_cyan       => { index: 33, pair: [COLOR_BLUE,COLOR_CYAN] },
      :blue_white      => { index: 34, pair: [COLOR_BLUE,COLOR_WHITE] },

      :magenta_black   => { index: 35, pair: [COLOR_MAGENTA,COLOR_BLACK] },
      :magenta_red     => { index: 36, pair: [COLOR_MAGENTA,COLOR_RED] },
      :magenta_green   => { index: 37, pair: [COLOR_MAGENTA,COLOR_GREEN] },
      :magenta_yellow  => { index: 38, pair: [COLOR_MAGENTA,COLOR_YELLOW] },
      :magenta_blue    => { index: 39, pair: [COLOR_MAGENTA,COLOR_BLUE] },
      :magenta_cyan    => { index: 40, pair: [COLOR_MAGENTA,COLOR_CYAN] },
      :magenta_white   => { index: 41, pair: [COLOR_MAGENTA,COLOR_WHITE] },

      :cyan_black      => { index: 42, pair: [COLOR_CYAN,COLOR_BLACK] },
      :cyan_red        => { index: 43, pair: [COLOR_CYAN,COLOR_RED] },
      :cyan_green      => { index: 44, pair: [COLOR_CYAN,COLOR_GREEN] },
      :cyan_yellow     => { index: 45, pair: [COLOR_CYAN,COLOR_YELLOW] },
      :cyan_blue       => { index: 46, pair: [COLOR_CYAN,COLOR_BLUE] },
      :cyan_magenta    => { index: 47, pair: [COLOR_CYAN,COLOR_MAGENTA] },
      :cyan_white      => { index: 48, pair: [COLOR_CYAN,COLOR_WHITE] },

      :white_black     => { index: 49, pair: [COLOR_WHITE,COLOR_BLACK] },
      :white_red       => { index: 50, pair: [COLOR_WHITE,COLOR_RED] },
      :white_green     => { index: 51, pair: [COLOR_WHITE,COLOR_GREEN] },
      :white_yellow    => { index: 52, pair: [COLOR_WHITE,COLOR_YELLOW] },
      :white_blue      => { index: 53, pair: [COLOR_WHITE,COLOR_BLUE] },
      :white_magenta   => { index: 54, pair: [COLOR_WHITE,COLOR_MAGENTA] },
      :white_cyan      => { index: 55, pair: [COLOR_WHITE,COLOR_CYAN] }
    }
  end

  # Used to color a group of Game strings...
  # eg.
  # Color.color :yellow_red do
  #  Game.str 0, 0, "Hello World"
  # end
  def self.color key, &block
    pair = color_pair self.colors[key][:index]
    attron pair
    block.call
    attroff pair
  end

  def self.init
    # allow curses to use colors
    # https://linux.die.net/man/3/start_color
    start_color

    self.colors.each do |key, value|
      # initializes a color-pair with curses
      # there is a pair colors because one is the foreground and the other is the background
      # https://linux.die.net/man/3/init_pair
      init_pair value[:index], value[:pair][0], value[:pair][1]
    end

    # use terminal's default colors
    # https://linux.die.net/man/3/use_default_colors
    use_default_colors
  end
end
