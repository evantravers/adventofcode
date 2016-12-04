require 'pry'

solution = ""

class Keypad
  KeyValues = [
    [nil, nil, 1,   nil, nil],
    [nil, 2,   3,   4,   nil],
    [5,   6,   7,   8,   9],
    [nil, "A", "B", "C", nil],
    [nil, nil, "D", nil, nil]
  ]

  def self.button x, y
    return KeyValues[y][x]
  end
end

class Pointer
  attr_accessor :x, :y

  def initialize
    @x = 1
    @y = 1
  end

  def move_pointer(x, y)
    #bound detection
    x = @x + x
    y = @y + y

    if x > 4
      x = 4
    end
    if x < 0
      x = 0
    end
    if y > 4
      y = 4
    end
    if y < 0
      y = 0
    end

    #weird shape detection
    unless Keypad.button(x, y) == nil
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

current_key = Pointer.new

File.foreach('input.txt') do |line|
  line.split('').each do |char|
    if char == "U"
      current_key.up
    elsif char == "D"
      current_key.down
    elsif char == "L"
      current_key.left
    elsif char == "R"
      current_key.right
    end
  end

  solution += "#{Keypad.button(current_key.x, current_key.y)}"
end

puts solution
