require 'pry'

class RenderWalls
  def self.render data
    rows    = data.size
    columns = data[0].size

    rendered = []
    data.each_with_index do |e,row|
      rendered[row] = ''
      e.each_with_index do |ee,column|
        piece = self.find_wall_piece(data,columns,rows,column,row)
        #puts "#{column}.#{row}: #{piece}"
        rendered[row] << piece
      end
    end
    rendered
  end

  def self.find_wall_piece data,columns,rows,column,row
    if data[row][column] == 'W'
      if self.corner_top_left?(data,columns,rows,column,row)
       '┏'
      elsif self.corner_top_right?(data,columns,rows,column,row)
       '┓'
      elsif self.corner_bottom_left?(data,columns,rows,column,row)
       '┗'
      elsif self.corner_bottom_right?(data,columns,rows,column,row)
       '┛'
      elsif self.horizontal?(data,columns,column,row)
       '━'
      elsif self.vertical?(data,rows,column,row)
       '┃'
      else
       '&'
      end
    else
      ' '
    end
  end

  def self.top_exist? row
    row > 0
  end

  def self.bottom_exist? rows, row
    row+1 < rows
  end

  def self.left_exist? column
    column > 0
  end

  def self.right_exist? columns, column
    column+1 < columns
  end

  # ━
  def self.horizontal? data, columns, column, row
     self.left_wall?(data,column,row) ||
     self.right_wall?(data,columns,column,row)
  end

  # ┃
  def self.vertical? data, rows, column, row
    self.top_wall?(data,column,row) ||
    self.bottom_wall?(data,rows,row,column)
  end

  # ╋
  def self.cross?

  end

  # ┳
  def self.t_top?

  end

  # ┻
  def self.t_bottom?

  end

  # ┣
  def self.t_left?
  end

  # ┫
  def self.t_right?
  end

  # ┏
  def self.corner_top_left? data, columns, rows, column, row
    !self.top_wall?(data,column,row) &&
    !self.left_wall?(data,column,row) &&
     self.bottom_wall?(data,rows,row,column) &&
     self.right_wall?(data,columns,column,row)
  end

  # ┓
  def self.corner_top_right? data, columns, rows, column, row
    !self.top_wall?(data,column,row) &&
    !self.right_wall?(data,columns,column,row) &&
     self.bottom_wall?(data,rows,row,column) &&
     self.left_wall?(data,column,row)
  end

  # ┗
  def self.corner_bottom_left? data, columns, rows, column, row
    !self.bottom_wall?(data,rows,row,column) &&
    !self.left_wall?(data,column,row) &&
     self.top_wall?(data,column,row) &&
     self.right_wall?(data,columns,column,row)
  end

  # ┛
  def self.corner_bottom_right? data, columns, rows, column, row
    !self.bottom_wall?(data,rows,row,column) &&
    !self.right_wall?(data,columns,column,row) &&
     self.top_wall?(data,column,row) &&
     self.left_wall?(data,column,row)
  end

  def self.right_wall?(data,columns,column,row)
    self.right_exist?(columns,column) && data[row][column+1] == 'W'
  end

  def self.left_wall?(data,column,row)
    self.left_exist?(column) && data[row][column-1] == 'W'
  end

  def self.top_wall?(data,column,row)
    self.top_exist?(row) && data[row-1][column] == 'W'
  end

  def self.bottom_wall?(data,rows,row,column)
    self.bottom_exist?(rows,row) && data[row+1][column] == 'W'
  end
end
