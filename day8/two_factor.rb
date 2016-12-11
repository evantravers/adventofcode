require 'pry'

class Screen
  def initialize(x, y)
    @monitor = Array.new(y) {Array.new(x, 0)}
  end

  def display
    @monitor.each do |y|
      y.each do |x|
        print "#{x}"
      end
      puts "\n"
    end
  end

  def rect(x, y)
  end

  def rotate_row (y, b)
    @monitor[y] = rotate(@monitor[y], b)
  end

  def rotate_column (x, b)
    array = 
    @monitor[y] = rotate(@monitor[y], b)
  end

  private

  def rotate(array, amount)
    right_index = amount + 1
    left_index  = amount

    temp_array = array[0..-right_index]
    remainder  = array[left_index..-1]

    return remainder.reverse + temp_array
  end
end

screen = Screen.new(4, 3)

screen.rect(2, 2)

binding.pry

screen.display
