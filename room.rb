require 'pry'
require "curses"
include Curses

class Room
  # Return what action should occur
  def self.tile_data(x,y,data,objects)
    if data[y].nil? || data[y][x].nil?
      return { 'handle' => :void }
    end
    if RenderWalls.wall?(data[y][x])
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

  def self.draw player_x, player_y, layout, objects, frame
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
      # states.frames.color
      # states.color
      # frames.color
      # color
      color =
      if obj['state'] &&
         obj['states'][obj['state']] &&
         obj['states'][obj['state']]['frames'] &&
         obj['states'][obj['state']]['frames'][frame.to_s] &&
         obj['states'][obj['state']]['frames'][frame.to_s]['color'] &&
        obj['states'][obj['state']]['frames'][frame.to_s]['color']
      elsif obj['state'] &&
            obj['states'][obj['state']] &&
            obj['states'][obj['state']]['color']
        obj['states'][obj['state']]['color']
      elsif obj['frames'] &&
            obj['frames'][frame.to_s] &&
            obj['frames'][frame.to_s]['color']
        obj['frames'][frame.to_s]['color']
      elsif obj['color']
        obj['color']
      end
      # states.frames.character
      # states.character
      # frames.character
      # character
      character =
      if obj['state'] &&
         obj['states'][obj['state']] &&
         obj['states'][obj['state']]['frames'] &&
         obj['states'][obj['state']]['frames'][frame.to_s] &&
         obj['states'][obj['state']]['frames'][frame.to_s]['character'] &&
        obj['states'][obj['state']]['frames'][frame.to_s]['character']
      elsif obj['state'] &&
            obj['states'][obj['state']] &&
            obj['states'][obj['state']]['character']
        obj['states'][obj['state']]['character']
      elsif obj['frames'] &&
            obj['frames'][frame.to_s] &&
            obj['frames'][frame.to_s]['character']
        obj['frames'][frame.to_s]['character']
      elsif obj['character']
        obj['character']
      end
      begin
      Game.str obj['position']['y']+((lines/ 2)-player_y),
               obj['position']['x']+(((cols-Dialog.width) / 2)-player_x),
               character,
               color
      rescue
        close_screen
        binding.pry
      end
    end
  end

  def self.update_room_states data
    data.room_objects.each do |obj|
      if obj['room_state'] && data.room_states
        data.room_states.each do |key,value|
          if obj['room_state'][key] && obj['room_state'][key][value.to_s]
            obj['state'] = obj['room_state'][key][value.to_s]
          end
        end
      end
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
      if obj['position']
        found =
        neighbours.find do |coords|
          obj['position']['x'] == coords[0] &&
          obj['position']['y'] == coords[1]
        end # neighbours
        case obj['handle'].to_sym
        when :door
          if found && [:tn,:nl,:nr,:bn].include?(found[2]) && obj['state'] == 'closed'
            obj['state'] = 'opened'
          elsif obj['state'] == 'opened'
            obj['state'] = 'closed'
          end
        end # obj['handle']
      end # obj['position']
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
      if future_tile['traverse']
        data.player_y = new_y
        data.player_x = new_x
        if future_tile['on'] && future_tile['on']['enter']
          future_tile['on']['enter'].each do |key,value|
            data.room_states[key.to_s] = value
          end
        end
      else
        case future_tile['handle'].to_sym
        when :force_field_decker
          data.dialog_selected_index = 0
          data.thread_key = :decker_holding_cell
          data.mode   = :dialog
        when :door
          if future_tile['state'] != 'locked'
            data.player_y = new_y
            data.player_x = new_x
          end
        when :empty
          data.player_y = new_y
          data.player_x = new_x
        end
      end
    end
  end
end
