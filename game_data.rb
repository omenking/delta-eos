class GameData
  attr_accessor :running,
                :player_room,
                :player_x,
                :player_y,
                :rooms,
                :mode,
                :dialog_selected_index,
                :threads,
                :thread,
                :exp

  def initialize
    self.dialog_selected_index = 0
    self.mode = :room
    self.running = true
    self.player_room = :holding_area
    self.player_x = 11
    self.player_y = 5
    self.rooms = {}
    self.threads = {}
    self.exp = 0
  end

  def dialog_action
    self.choices[self.dialog_selected_index][:action]
  end

  def level
    (0.08 * Math.sqrt(self.exp)).floor
  end

  def next_exp
    val = (self.level+1) / 0.08
    (val*val).floor
  end

  def prev_exp
    val = (self.level) / 0.08
    (val*val).floor
  end

  def layout_to_array data
    data.split("\n").map do |row|
      row.upcase.split('')
    end
  end

  def add_room key, layout_file, metadata_file
    layout_data = File.read layout_file
    metadata    = JSON.parse File.read(metadata_file)
    layout      = self.layout_to_array(layout_data)

    objects = []
    object_id = 0

    layout.each_with_index do |e,row|
      e.each_with_index do |ee,column|
        if metadata['objects'].key?(layout[row][column])
          object = metadata['objects'][layout[row][column]].clone
          object['object_id'] = object_id
          object['position'] = {
            'x'         => column,
            'y'         => row
          }
          object_id += 1
          objects.push object
          layout[row][column] = ' '
        end
      end
    end
    #close_screen
    #binding.pry
    metadata['objects'] = objects

    self.rooms[key] = {
      'layout'   => layout,
      'metadata' => metadata
    }
  end

  def add_thread key, thread_file
    thread = JSON.parse File.read(thread_file)
    self.threads[key.to_sym] = thread
  end

  def strand
    return nil unless self.thread
    state = self.threads[self.thread.to_sym]['state']
    self.threads[self.thread.to_sym]['strands'][state]
  end

  def strand_result
    result_key = self.strand['choices'][dialog_selected_index]['result']
    self.threads[self.thread]['results'][result_key]
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
