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
    return array.rotate(array.length - amount)
  end
end

screen = Screen.new(4, 3)

screen.rect(2, 2)

binding.pry

screen.display
