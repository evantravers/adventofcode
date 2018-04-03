require 'minitest/autorun'

class Position
  attr_accessor :x, :y, :z, :history

  def initialize
    @x = 0
    @y = 0
    @z = 0

    @history = []
  end

  def inspect
    "X: #{@x}, Y: #{@y}, Z: #{@z}\n"
  end

  def n
    @history.push self.clone

    @y += 1
    @z -= 1
  end

  def ne
    @history.push self.clone

    @x += 1
    @z -= 1
  end

  def se
    @history.push self.clone

    @x += 1
    @y -= 1
  end

  def s
    @history.push self.clone

    @z += 1
    @y -= 1
  end

  def sw
    @history.push self.clone

    @z += 1
    @x -= 1
  end

  def nw
    @history.push self.clone

    @y += 1
    @x -= 1
  end

  def distance
    (@x.abs + @y.abs + @z.abs)/2
  end
end

def track(instructions)
  position = Position.new

  instructions.each do |direction|
    position.send(direction)
  end

  position
end

def p1
  instructions = File.read("./input.txt").strip.split(",")
  track(instructions).distance
end

def p2
  instructions = File.read("./input.txt").strip.split(",")
  track(instructions).history.map{|x| x.distance }.max
end

puts "Part 1:"
puts p1
puts "Part 2:"
puts p2

class HexTest < Minitest::Test
  def test_distance_1
    assert_equal 3, track(["ne","ne","ne"]).distance
  end
  def test_distance_2
    assert_equal 0, track(["ne","ne","sw","sw"]).distance
  end
  def test_distance_3
    assert_equal 2, track(["ne","ne","s","s"]).distance
  end
  def test_distance_4
    assert_equal 3, track(["se","sw","se","sw","sw"]).distance
  end
end
