require 'set'
require 'pry'

class Maze
  @map = []

  def initialize number
    @designers_favorite_number = number.to_i
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
    @target_x == x && @target_y == y
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

  def solve x, y, instrument=false
    @target_x, @target_y = x, y

    # starting at 1, 1
    position = {coords: [1, 1], steps: 0}
    queue    = [position]
    visited  = Set.new
    allrooms = Set.new
    distance = 0

    until queue.empty?
      current = queue.shift

      if victory?(*current[:coords])
        distance = current[:steps]
      end

      unless visited.include? current[:coords]
        visited  << current[:coords]
        allrooms << current
        queue    += possible_moves(current, visited)
      end

      display(current, visited) if instrument
    end

    max_locations = allrooms.select { |loc| loc[:steps] <= 50 }.size
    return "Reached goal in #{distance} steps, max locations is #{max_locations}."
  end

  def display current_position, visited
    sleep 0.25
    system "clear"
    dimension = 50
    map = ""
    (0..dimension).each do |y|
      (0..dimension).each do |x|
        if current_position[:coords] == [x, y]
          map += "😅"
        elsif visited.include? [x, y]
          map += "o"
        elsif x == @target_x && y == @target_y
          map += "⛱"
        elsif @maze.is_space?(x, y)
          map += "." 
        else
          map += "#"
        end
      end
      map += "\n"
    end
    puts map
  end
end

puts "TEST:\n"
test = Maze.new(10)
runner = MazeRunner.new(test)
puts runner.solve(7, 4)

puts "PROBLEM:\n"
problem = Maze.new(1364)
runner  = MazeRunner.new(problem)
puts runner.solve(31, 39)
