class GameData
  attr_accessor :running,
                :player_room,
                :player_x,
                :player_y,
                :rooms

  def initialize
    self.running = true
    self.player_room = :security_office
    self.player_x = 2
    self.player_y = 2
    self.rooms = {}
  end

  def layout_to_array data
    data.split("\n").map do |row|
      row.split('')
    end
  end

  def add_room key, layout_file, metadata_file
    layout_data = File.read layout_file
    metadata    = JSON.parse File.read(metadata_file)
    layout      = self.layout_to_array(layout_data)

    layout.each_with_index do |e,row|
      e.each_with_index do |ee,column|
        if metadata['objects'].key?(layout[row][column])
          metadata['objects'][layout[row][column]]['position'] = {
            'x' => column,
            'y' => row
          }
          layout[row][column] = ' '
        end
      end
    end

    self.rooms[key] = {
      'layout'   => layout,
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
