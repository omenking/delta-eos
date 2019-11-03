#https://docs.ruby-lang.org/en/2.0.0/Curses.html
https://stackoverflow.com/questions/46606653/how-do-i-get-a-bright-white-background-color-with-ncurses
https://www.linuxjournal.com/content/programming-color-ncurses
https://www.pinterest.ca/pin/160440805446947199/?lp=true
https://nomediakings.org/games/guilded-youth-a-text-game-with-ascii-animation.html
http://ascii-table.com/ascii-extended-pc-list.php
https://www.linuxjournal.com/content/about-ncurses-colors-0
## crmode
Put the terminal into cbreak mode.

## setpos(y, x)
A setter for the position of the cursor, using coordinates x and y

## addstr
add a string of characters str, to the window and advance cursor

## refresh
Refreshes the windows and lines.

## getch
Read and returns a character from the window.

## close_screen

A program should always call ::close_screen before exiting or escaping from curses mode temporarily. This routine restores tty modes, moves the cursor to the lower left-hand corner of the screen and resets the terminal into the proper non-visual mode.
