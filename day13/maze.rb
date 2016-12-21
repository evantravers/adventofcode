require 'set'
require 'pry'

class Maze
  @map = []

  def initialize number, dimension=10
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
    return @map
  end

  def inspect
    map = ""
    grid.transpose.each do |x|
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
    @maze  = maze
  end

  def victory? x, y
    @target_y == x && @target_x == y
  end

  def possible_moves parent_move
    x, y = parent_move[:coords]

    moves = []
    [[x+1, y], [x-1, y], [x, y+1], [x, y-1]].each do |move|
      if @maze.is_space?(*move)
        moves << {coords: move, steps: parent_move[:steps] + 1}
      end
    end
    return moves
  end

  def solve x, y
    @target_x, @target_y = x, y

    # starting at 1, 1
    position = {coords: [1, 1], steps: 0}
    queue    = [position]
    visited  = Set.new

    until queue.empty?
      current = queue.shift

      if victory? *current[:coords]
        return current[:steps]
      end

      unless visited.include? current[:coords]
        # only store position, not steps
        visited << current[:coords]

        queue += possible_moves(current)
      end

      # puts "queue: #{queue.size}, visited: #{visited.size}, depth: #{current[:steps]}"
    end
  end
end

puts "TEST:\n"
test = Maze.new(10)
runner = MazeRunner.new(test)
puts runner.solve(4, 7)

puts "PROBLEM:\n"
problem  = Maze.new(1364, 200)
plissken = MazeRunner.new(problem)
puts plissken.solve(31, 39)
