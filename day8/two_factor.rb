require 'pry'

class Screen
  def initialize(x, y)
    @monitor = Array.new(y) {Array.new(x, 0)}
  end

  def eval line
    regex_rect = /rect (\d+)x(\d+)/
    regex_row  = /rotate row y=(\d+) by (\d+)/
    regex_col  = /rotate column x=(\d+) by (\d+)/

    if line.match(regex_rect)
      values = line.match(regex_rect)
      x, y = values[1].to_i, values[2].to_i
      rect(x, y)
    elsif line.match(regex_row) 
      values = line.match(regex_row)
      y, b = values[1].to_i, values[2].to_i
      rotate_row(y, b)
    elsif line.match(regex_col) 
      values = line.match(regex_col)
      x, b = values[1].to_i, values[2].to_i
      rotate_col(x, b)
    end

    display
  end

  def display
    puts "===================================================================="
    @monitor.each do |y|
      y.each do |x|
        print "#" if x == 1
        print " " if x == 0
      end
      puts "\n"
    end
    puts "===================================================================="
  end

  def rect(x, y)
    x = x-1
    y = y-1

    (0..y).each do |y_index|
      (0..x).each do |x_index|
        @monitor[y_index][x_index] = 1
      end
    end
  end

  def rotate_row (y, b)
    @monitor[y] = rotate(@monitor[y], b)
  end

  def rotate_col (x, b)
    column = @monitor.map { |row| row[x] }
    column = rotate(column, b)

    column.each_with_index do |value, index|
      @monitor[index][x] = value
    end
  end

  def solve
    return @monitor.flatten.inject(:+)
  end

  private

  def rotate(array, amount)
    return array.rotate(array.length - amount)
  end
end

screen = Screen.new(50, 6)

File.foreach('input.txt') do |line|
  screen.eval(line)
end

puts "The solution is:"
puts screen.solve
