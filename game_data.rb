class GameData
  attr_accessor :running,
                :player_room,
                :player_x,
                :player_y,
                :rooms

  def initialize
    self.running = true
    self.player_room = :hall
    self.player_x = 3
    self.player_y = 2
    self.rooms = {}
  end

  def layout_to_array data
    data.split("\n").map do |row|
      row.split('')
    end
  end

  def add_room key, layout, metadata
    layout   = File.read layout
    metadata = JSON.parse(File.read(metadata))
    self.rooms[key] = {
      'layout'   => self.layout_to_array(layout),
      'metadata' => metadata
    }
  end

  def room_name
    self.rooms[self.player_room]['metadata']['name']
  end

  def room_layout
    self.rooms[self.player_room]['layout']
  end

  def room_objects
    self.rooms[self.player_room]['metadata']['objects']
  end
end
