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
    self.left_exist?(column) &&
    self.right_exist?(columns,column) &&
    data[row][column+1] == 'W' &&
    data[row][column-1] == 'W'
  end

  # ┃
  def self.vertical? data, rows, column, row
    self.top_exist?(row) &&
    self.bottom_exist?(rows,row) &&
    data[row+1][column] == 'W' &&
    data[row-1][column] == 'W'
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
    (!self.top_exist?(row) || data[row-1][column] != 'W') && #top is not wall
    (!self.left_exist?(column) || data[row][column-1] != 'W') && #left is not wall
    self.bottom_exist?(rows,row)      && data[row+1][column] == 'W' &&  # bottom is wall
    self.right_exist?(columns,column) && data[row][column+1] == 'W'     # right is wall
  end

  # ┓
  def self.corner_top_right? data, columns, rows, column, row
    (!self.top_exist?(row) || data[row-1][column] != 'W') && #top is not wall
    (!self.right_exist?(columns,column) || data[row][column+1] != 'W') && #right is not wall
    self.bottom_exist?(rows,row) && data[row+1][column] == 'W' &&  # bottom is wall
    self.left_exist?(column) && data[row][column-1] == 'W'     # left is wall
  end

  # ┗
  def self.corner_bottom_left? data, columns, rows, column, row
    (!self.bottom_exist?(rows,row) || data[row+1][column] != 'W') && #bottom is not wall
    (!self.left_exist?(column) || data[row][column-1] != 'W') && #left is not wall
    (!self.top_exist?(row) || data[row-1][column] == 'W') && #top is  wall
    self.right_exist?(columns,column) && data[row][column+1] == 'W'     # right is wall
  end

  # ┛
  def self.corner_bottom_right? data, columns, rows, column, row
    (!self.bottom_exist?(rows,row) || data[row+1][column] != 'W') && #bootom is not wall
    (!self.right_exist?(columns,column) || data[row][column+1] != 'W') && #right is not wall
    (!self.top_exist?(row) || data[row-1][column] == 'W') && #top is  wall
    self.left_exist?(column) && data[row][column-1] == 'W'     # left is wall
  end
end
