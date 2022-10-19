require 'pry'
require "curses"
include Curses

class Game
  def self.init
    # https://linux.die.net/man/3/timeout
    timeout = 500

    # https://pubs.opengroup.org/onlinepubs/7908799/xcurses/initscr.html
    init_screen

    # hide cursor
    # https://linux.die.net/man/3/curs_set
    curs_set(0) 
    
    # Put the terminal into cbreak mode.
    # disables line buffering and erase/kill character-processing (interrupt and flow control characters are unaffected), 
    # making characters typed by the user immediately available to the program.
    # https://www.rubydoc.info/gems/curses/Curses.crmode
    crmode

    Color.init

    # refresh curses windows and lines
    # https://linux.die.net/man/3/refresh
    refresh
  end

  # Each gameloop which occurs in main.rb will call
  # this action to translate the input into a symbol that represents
  # the action. 
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

  # Used to draw a string
  # eg. 
  # Game.str 0, 0, "Hello World", :yellow_red
  def self.str x, y, str, color=nil
    if color
      Color.color color.to_sym do
        # Moves the cursor (hot spot) to the global screen position (x, y)
        setpos x, y

        # add a string of characters to a curses window and advance cursor
        # https://linux.die.net/man/3/addstr
        addstr str
      end
    else
      # Moves the cursor (hot spot) to the global screen position (x, y)
      setpos x, y

      # add a string of characters to a curses window and advance cursor
      # https://linux.die.net/man/3/addstr
      addstr str
    end
  end

  def self.draw data
    # Clear the window
    # https://linux.die.net/man/3/clear
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
      data.morale,
      data.points_used
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
    SkillsOverlay.draw(
      data.mode,
      data.skill_selected_index,
      data.skills,
      data.level,
      data.points_used
    )
    InventoryOverlay.draw(
      data.mode,
      data.inventory,
      data.inventory_database
    )

    # refresh curses windows and lines
    # https://linux.die.net/man/3/refresh
    refresh
  end
end
