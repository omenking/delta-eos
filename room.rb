require 'pry'
require "curses"
include Curses

class Room
  # Return what action should occur
  def self.tile_data(x,y,data,objects)
    if data[y].nil? || data[y][x].nil?
      return { 'handle' => :void }
    end
    if data[y][x] == 'W'
      { 'handle' => :wall  }
    else
      object =
      objects.find do |obj|
        obj['position']['x'] == x &&
        obj['position']['y'] == y
      end
      if object
        object
      else
        { 'handle' => :empty }
      end
    end
  end

  def self.draw player_x, player_y, layout, objects
    rendered = RenderWalls.render layout
    y = 0
    rendered.each do |row|
      Game.str(
        (lines/ 2)+y-player_y,
        ((cols-Dialog.width) / 2)-player_x,
        row
      )
      y += 1
    end
    objects.each do |obj|
        character = if obj['character']
          obj['character']
        else
          obj['states'][obj['state']]['character']
        end
        color = if obj['color']
          obj['color']
        elsif obj['state']
          obj['states'][obj['state']]['color']
        end
        Game.str obj['position']['y']+((lines/ 2)-player_y),
                 obj['position']['x']+(((cols-Dialog.width) / 2)-player_x),
                 character,
                 color
    end
  end

  def self.check_neighbours data
    neighbours = [
      [-1,-1,:tl],[-1,0,:tn],[-1,1,:tr],
      [ 0,-1,:nl],           [0 ,1,:nr],
      [ 1,-1,:bl],[ 1,0,:bn],[1 ,1,:br]
    ].map do |coords|
      x = data.player_x + coords[0]
      y = data.player_y + coords[1]
      [x,y,coords[2]]
    end

    data.room_objects.each do |obj|
      found =
      neighbours.find do |coords|
        obj['position']['x'] == coords[0] &&
        obj['position']['y'] == coords[1]
      end # neighbours
      case obj['handle'].to_sym
      when :door
        if found && [:tn,:nl,:nr,:bn].include?(found[2])
          obj['state'] = 'opened'
        else
          obj['state'] = 'closed'
        end
      end
    end # objects
  end

  def self.actions data, action
    x     = data.player_x
    y     = data.player_y
    new_x = data.player_x
    new_y = data.player_y
    case action
    when :up    then new_y = Player.up    y
    when :down  then new_y = Player.down  y
    when :left  then new_x = Player.left  x
    when :right then new_x = Player.right x
    when :health
      data.health[:stock]   = data.health[:stock] - 1
      data.health[:current] = data.health[:current] + 1
    when :morale
      data.morale[:stock]   = data.morale[:stock] - 1
      data.morale[:current] = data.morale[:current] + 1
    when :skills
      data.mode = :overlay
    when :inv
      data.mode = :overlay
    end

    current_tile = Room.tile_data x    , y    , data.room_layout, data.room_objects
    future_tile  = Room.tile_data new_x, new_y, data.room_layout, data.room_objects

    case current_tile['handle'].to_sym
    when :door
      if current_tile['exit_action'].to_sym == action
        data.player_room = current_tile['exit_room'].to_sym
        data.player_y    = current_tile['exit_position']['y']
        data.player_x    = current_tile['exit_position']['x']
      else
        case future_tile['handle'].to_sym
        when :empty
          data.player_y = new_y
          data.player_x = new_x
        end
      end
    else
      case future_tile['handle'].to_sym
      when :force_field_decker
        data.dialog_selected_index = 0
        data.thread_key = :decker_holding_cell
        data.mode   = :dialog
      when :door
        data.player_y = new_y
        data.player_x = new_x
      when :empty
        data.player_y = new_y
        data.player_x = new_x
      end
    end
  end
end
