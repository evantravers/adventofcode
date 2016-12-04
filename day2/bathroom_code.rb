require 'pry'

solution = ""

class Keypad
  KeyValues = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
  ]

  def button x, y
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
    @x += x
    @y += y

    if @x > 2
      @x = 2
    end
    if @x < 0
      @x = 0
    end
    if @y > 2
      @y = 2
    end
    if @y < 0
      @y = 0
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
keypad      = Keypad.new

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

  solution += "#{keypad.button(current_key.x, current_key.y)}"
end

puts solution
