require 'set'
require 'pry'

class Maze
  @map = []

  def initialize number
    @designers_favorite_number = number
  end

  def is_space? x, y
    x, y = x.to_i, y.to_i
    secret_formula = x*x + 3*x + 2*x*y + y + y*y

    number = secret_formula + @designers_favorite_number
    return number.to_s(2).scan("1").size.even?
  end
end

class MazeRunner
  def initialize maze
    @maze  = maze
  end

  def victory? x, y
    @target_y == x && @target_x == y
  end

  def possible_moves parent_move, visited
    x, y = parent_move[:coords]

    moves = []
    [[x+1, y], [x-1, y], [x, y+1], [x, y-1]].each do |move|
      if @maze.is_space?(*move) && !visited.include?(move) && move.min >= 0
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
      current = queue.pop

      if victory?(*current[:coords])
        return current[:steps]
      end

      unless visited.include? current[:coords]
        visited << current[:coords]
        queue += possible_moves(current, visited)
      end

      puts display(current, visited)
    end
  end

  def display current_position, visited
    dimension = 50
    map = ""
    (0..dimension).each do |y|
      (0..dimension).each do |x|
        if current_position[:coords] == [x, y]
          map += "😅"
        elsif visited.include? [x, y]
          map += "o"
        elsif [y, x] == [@target_x, @target_y]
          map += "⛱"
        elsif @maze.is_space?(x, y)
          map += "." 
        else
          map += "#"
        end
      end
      map += "\n"
    end
    map += "=" * dimension.abs
    sleep 0.25
    return map
  end
end

puts "TEST:\n"
test = Maze.new(10)
runner = MazeRunner.new(test)
puts runner.solve(4, 7)

puts "PROBLEM:\n"
problem = Maze.new(1364)
runner  = MazeRunner.new(problem)
puts runner.solve(31, 39)
