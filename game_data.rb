class GameData
  attr_accessor :running,
                :player_room,
                :player_x,
                :player_y,
                :rooms,
                :mode,
                :dialog_selected_index,
                :skill_selected_index,
                :threads,
                :thread_key,
                :exp,
                :skills,
                :health,
                :morale,
                :frame,
                :points_used,
                :scanning,
                :inventory,
                :inventory_database,
                :equipped

  def initialize
    self.dialog_selected_index = 0
    self.mode = :room
    self.running = true
    self.player_room = :security_office
    self.player_x = 3
    self.player_y = 3
    self.skill_selected_index = 0
    self.rooms = {}
    self.threads = {}
    self.exp = 1000
    self.frame = 0
    self.points_used = 0
    self.scanning = false
    self.health = {
      current: 1,
      max: 6,
      stock: 3
    }
    self.morale = {
      current: 2,
      max: 2,
      stock: 1
    }
    self.inventory_database = {}
    self.inventory = []
    self.equipped = {
      head: nil,
      chest: nil,
      legs: nil,
      left_hand: nil,
      right_hand: nil,
      feet: nil
    }
    self.skills = {
      brains: 3,
      enthusiasm: 1,
      logic: 0,
      knowledge: 1,
      hacking: 0,
      brawns: 2,
      endurance: 0,
      reaction: 0,
      muscle: 0,
      authority: 0,
      luck: 2,
      acting: 0,
      hunches: 1,
      perception: 0,
      mysticsm: 0
    }
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

  def add_inv inv_file
    self.inventory_database = JSON.parse File.read(inv_file)
  end

  def thread
    return nil unless self.thread_key
    self.threads[self.thread_key.to_sym]
  end

  def strand
    return nil unless self.thread_key
    state = self.threads[self.thread_key.to_sym]['state']
    self.threads[self.thread_key.to_sym]['strands'][state]
  end

  def strand_result
    result_key = self.strand['choices'][dialog_selected_index]['result']
    self.threads[self.thread_key]['results'][result_key]
  end

  def room
    self.rooms[self.player_room]
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

  def room_states
    self.rooms[self.player_room]['metadata']['states']
  end
end
