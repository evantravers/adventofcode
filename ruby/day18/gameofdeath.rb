require 'minitest/autorun'
require 'pry'

INPUT = "^..^^.^^^..^^.^...^^^^^....^.^..^^^.^.^.^^...^.^.^.^.^^.....^.^^.^.^.^.^.^.^^..^^^^^...^.....^....^.".freeze

class Room
  def initialize input, length
    # true == trap
    @rows = {}
    @rows[0] = input.split('').map.with_index { |x, i| [i, x == '^'] }.to_h

    until @rows.size == length
      y = @rows.size
      row = {}
      (0...input.length).map do |x|
        row[x] = is_trap?(x, y)
      end
      @rows[y] = row
    end
  end

  def solve
    return @rows.values.map(&:values).flatten.select {|x| !x }.count
  end

  def trap? tile
    tile == true
  end

  def safe? tile
    !trap?(tile)
  end

  def is_trap? x, y
    previous_row = @rows[y-1]
    left   = previous_row[x-1]
    center = previous_row[x]
    right  = previous_row[x+1]
    return true if trap?(left) && trap?(center) && safe?(right)
    return true if trap?(center) && trap?(right) && safe?(left)
    return true if trap?(left) && safe?(right) && safe?(center)
    return true if trap?(right) && safe?(left) && safe?(center)
    return false
  end
end

class BombTest < Minitest::Test
  def test_1
    room   = Room.new('.^^.^.^^^^', 10)
    assert_equal room.solve, 38
  end
end

puts "Part 1:"
puts Room.new(INPUT, 40).solve
puts "Part 2:"
puts Room.new(INPUT, 400000).solve
