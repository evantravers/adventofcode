require 'set'

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
    @maze  = maze
  end

  def victory? x, y
    @target_y == x && @target_x == y
  end

  def possible_moves parent_move
    x, y = parent_move[:pos]

    moves = []
    [[x+1, y], [x-1, y], [x, y+1], [x, y-1]].each do |move|
      if @maze.is_space?(*move)
        moves << {pos: move, parent: parent_move}
      end
    end
    return moves
  end

  def solve x, y
    @target_x, @target_y = x, y

    @visited          = []
    queue            = [{pos: [1, 1], parent: nil}]

    def i_have_seen_this_before? position
      return @visited.find {|x| x[:pos] == position[:pos] }
    end

    until queue.empty?
      position = queue.pop

      if victory?(*position[:pos])
        results = []
        while position[:parent]
          results << position[:parent]
          position = position[:parent]
        end
        return results.size
      end

      unless i_have_seen_this_before? position
        @visited << position
        queue   += possible_moves(position)
      end
    end
  end
end

puts "TEST:\n"
test = Maze.new(10, 9)
runner = MazeRunner.new(test)
puts runner.solve(4, 7)

puts "PROBLEM:\n"
problem  = Maze.new(1364, 40)
plissken = MazeRunner.new(problem)
puts plissken.solve(31, 39)
