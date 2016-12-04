require 'pry'

solution1 = ""
solution2 = ""

KeyValues = [
  [nil, nil, nil, nil, nil],
  [nil, 1, 2, 3, nil],
  [nil, 4, 5, 6, nil],
  [nil, 7, 8, 9, nil],
  [nil, nil, nil, nil, nil]
]
FancyKeyValues = [
  [nil, nil, nil, nil, nil, nil, nil],
  [nil, nil, nil, 1,   nil, nil, nil],
  [nil, nil, 2,   3,   4,   nil, nil],
  [nil, 5,   6,   7,   8,   9, nil],
  [nil, nil, "A", "B", "C", nil, nil],
  [nil, nil, nil, "D", nil, nil, nil],
  [nil, nil, nil, nil, nil, nil, nil]
]

class Keypad
  @pad = nil

  def initialize pad_values
    @pad = pad_values
  end

  def button x, y
    return @pad[y][x]
  end
end

problem1_pad = Keypad.new(KeyValues)
problem2_pad = Keypad.new(FancyKeyValues)

class Pointer
  attr_accessor :x, :y

  def initialize x, y, keypad
    @x = x
    @y = y
    @keypad = keypad
  end

  def move_pointer(x, y)
    x = @x + x
    y = @y + y

    unless @keypad.button(x, y) == nil
      @x = x
      @y = y
    end
  end

  def left
    move_pointer(-1, 0)
  end

  def right
    move_pointer(1, 0)
  end

  def up
    move_pointer(0, -1)
  end

  def down
    move_pointer(0, 1)
  end
end

problem1 = Pointer.new(2, 2, problem1_pad)
problem2 = Pointer.new(3, 3, problem2_pad)

File.foreach('input.txt') do |line|
  line.split('').each do |char|
    if char == "U"
      problem1.up
      problem2.up
    elsif char == "D"
      problem1.down
      problem2.down
    elsif char == "L"
      problem1.left
      problem2.left
    elsif char == "R"
      problem1.right
      problem2.right
    end
  end

  solution1 += "#{problem1_pad.button(problem1.x, problem1.y)}"
  solution2 += "#{problem2_pad.button(problem2.x, problem2.y)}"
end

puts "Imaginary Keypad (Problem Part 1)"
puts solution1

puts "Real Keypad (Problem Part 2)"
puts solution2
