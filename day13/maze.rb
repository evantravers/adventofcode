require 'pry'

class Maze
  @map = []

  def initialize number, dimension
    @designers_favorite_number = number

    generate(dimension)
  end

  def is_wall? x, y
    x, y = x.to_i, y.to_i
    secret_formula = x*x + 3*x + 2*x*y + y + y*y

    number = secret_formula + @designers_favorite_number
    return number.to_s(2).scan("1").size.odd?
  end

  def generate dimension
    @map = Array.new

    (0..dimension).each do |y|
      @map[y] = Array.new
      (0..dimension).each do |x|
        @map[y][x] = is_wall?(x, y)
      end
    end
  end

  def inspect
    map = ""
    @map.each do |x|
      x.each do |y|
        map += "#" if y
        map += "." if !y
      end
      map += "\n"
    end
    return map
  end
end

test = Maze.new(10, 9)
puts test.inspect
