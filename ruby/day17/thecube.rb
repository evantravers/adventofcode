require 'minitest/autorun'
require 'digest'
require 'set'
require 'pry'

class Maze
  def initialize salt
    @salt = salt
    @md5 = Digest::MD5.new
  end

  def solve(find_longest: false)
    solutions = Set.new
    todo      = [[]]

    until todo.empty?
      path = todo.shift

      if current_position(path) == [3, 3]
        # finishing state
        return path.join.upcase unless find_longest
        solutions << path.size
      else
        possible_moves = available_moves(path)
        possible_moves.map do |move|
          todo << (path.dup << move)
        end
      end
    end

    return solutions.max
  end

  def open_door? char
    ['b', 'c', 'd', 'e', 'f'].include? char
  end

  def available_moves path
    working_path = path.dup
    hash         = @md5.hexdigest(@salt + working_path.join.upcase)
    open_doors   = hash[0..3].split('').map { |x| open_door? x }
    available    = []

    [[:U, 0], [:D, 1], [:L, 2], [:R, 3]].each do |direction, indice|
      if open_doors[indice] && in_bounds(current_position(working_path << direction))
        available << direction
      end
    end
    return available
  end

  def current_position path
    x, y = 0, 0
    path.each do |step|
      case step
        when :U then y -= 1
        when :D then y += 1
        when :L then x -= 1
        when :R then x += 1
      end
    end
    [x, y]
  end

  def in_bounds coords
    x, y = coords
    (0..3).include?(x) && (0..3).include?(y)
  end
end

class SolutionTests < Minitest::Test
  def test_doors
    maze = Maze.new('hijkl')
    assert_equal maze.available_moves([]), [:D]
    assert_equal maze.available_moves([:D]), [:U, :R]
  end

  def test_current_position
    maze = Maze.new('hijkl')
    assert_equal maze.current_position([:D]), [0, 1]
    assert_equal maze.current_position([:D, :U]), [0, 0]
    assert_equal maze.current_position([:D, :U, :R, :D, :D]), [1, 2]
  end

  def test_solve_1
    maze = Maze.new('ihgpwlah')
    assert_equal maze.solve, 'DDRRRD'
    assert_equal maze.solve(find_longest: true), 370
  end

  def test_solve_2
    maze = Maze.new('kglvqrro')
    assert_equal maze.solve, 'DDUDRLRRUDRD'
    assert_equal maze.solve(find_longest: true), 492
  end

  def test_solve_3
    maze = Maze.new('ulqzkmiv')
    assert_equal maze.solve, 'DRURDRUDDLLDLUURRDULRLDUUDDDRR'
    assert_equal maze.solve(find_longest: true), 830
  end
end

puts "Part 1:"
puts Maze.new('udskfozm').solve

puts "Part 2:"
puts Maze.new('udskfozm').solve(find_longest: true)
