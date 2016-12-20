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
end

test = Maze.new(10, 9)
puts test.inspect
