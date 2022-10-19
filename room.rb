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

  # Room.check_neighbours is for changing the state of
  # the objects based on if the player is standing (or not)
  # standing beside an objects.
 
  # Note: right now check_neighbours is just for handling doors
  # to automatically open and close when players are beside them.
  def self.check_neighbours data
    # Lets build a matrix so we check what neigbouring
    # square is around the player
    # This is what these symbols mean:
    # tl = top left
    # tl = top natural
    # tr = top right
    # nl = natural left
    # nr = natural right
    # bl = bottom left
    # br = bottom right
    # bn = bottom natural
    neighbours = [
      [-1,-1,:tl],[-1,0,:tn],[-1,1,:tr],
      [ 0,-1,:nl],           [0 ,1,:nr],
      [ 1,-1,:bl],[ 1,0,:bn],[1 ,1,:br]
    ].map do |coords|
      # using the players current coodrinates
      # we build our new matrix to have absolute player coorindates
      # of each neigbouring room coordinates.
      x = data.player_x + coords[0]
      y = data.player_y + coords[1]
      [x,y,coords[2]]
    end

    # lets iterate through each object found in the room
    # and determine if whe should change the state of objects
    # based on where the user player is stnading.
    data.room_objects.each do |obj|
      # if an object doesn't have a position (coordinate) than it does not 
      # the physically exist in the room, so will skip it.
      next unless obj['position']

      #did we find something?
      found =
      neighbours.find do |coords|
        obj['position']['x'] == coords[0] &&
        obj['position']['y'] == coords[1]
      end # neighbours

      # lets take a look at the objects in the room
      case obj['handle'].to_sym
      when :door
        # any natural direction will have a door (corners dont have doors)
        # if we are standing beside an unlocked door, open it to show the player
        # we can move  through it to another room
        if found && [:tn,:nl,:nr,:bn].include?(found[2]) && obj['state'] == 'closed'
          obj['state'] = 'opened'
        # if door was open, and now the player is no longer standing beside it
        # close the door. This is futurist ship, so doors close on their own.
        elsif obj['state'] == 'opened'
          obj['state'] = 'closed'
        end
      end # obj['handle']

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
      data.mode = :skills_overlay
    when :inv
      data.mode = :inventory_overlay
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
        when :door
          if future_tile['state'] != 'locked'
            data.player_y = new_y
            data.player_x = new_x
          end
        when :empty
          data.player_y = new_y
          data.player_x = new_x
        else
          if future_tile['on'] &&
             future_tile['on']['interact'] &&
             future_tile['on']['interact']['thread_key']
            key = future_tile['on']['interact']['thread_key'].to_sym
            thread = data.threads[key]
            if thread && thread['state'] != 'end'
              data.dialog_selected_index = 0
              data.thread_key            = key
              data.mode                  = :dialog
            end
          end
        end # case future_tile['handle'].to_sym
      end # if future_tile['traverse']
    end # case current_tile['handle'].to_sym
  end # def self.actions data, action
end # class Room