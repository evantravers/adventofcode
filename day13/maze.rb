class Maze
  @map = []

  def initialize number, dimension
    @designers_favorite_number = number

    generate(dimension)
  end

  def is_space? x, y
    x, y = x.to_i, y.to_i
    secret_formula = x*x + 3*x + 2*x*y + y + y*y

    number = secret_formula + @designers_favorite_number
    return number.to_s(2).scan("1").size.even?
  end

  def generate dimension
    @map = Array.new(dimension)
    (0..dimension).each do |x|
      @map[x] = Array.new(dimension, false)
      (0..dimension).each do |y|
        @map[x][y] = is_space?(x, y)
      end
    end
  end

  def grid
    return @map.transpose
  end

  def inspect
    map = ""
    grid.each do |x|
      x.each do |y|
        map += "." if y
        map += "#" if !y
      end
      map += "\n"
    end
    return map
  end
end

class MazeRunner
  def initialize maze
    @x, @y= 1, 1
    @maze = maze
  end

  def solve x, y
    @target_x, @target_y = x, y
    # TODO write method to actually *solve* the situation
  end

  def inspect
    string = ""
    @maze.grid.each_with_index do |x, x_index|
      x.each_with_index do |y, y_index|
        if x_index == @x && y_index == @y
          string += "O"
        elsif x_index == @target_x && y_index == @target_y
          string += "X"
        else
          string += "." if y
          string += "#" if !y
        end
      end
      string += "\n"
    end
    return string
  end
end

puts "TEST:\n"
test = Maze.new(10, 9)
runner = MazeRunner.new(test)
runner.solve(4, 7)
puts runner.inspect

puts "\n\nPROBLEM:\n"
problem  = Maze.new(1364, 40)
plissken = MazeRunner.new(problem)
plissken.solve(31, 39)
puts plissken.inspect
