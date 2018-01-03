require 'minitest/autorun'

def checksum(sheet)
  sum = 0

  sheet.each do |line|
    values     = line.split(' ').map(&:to_i)
    difference = values.max - values.min
    sum        += difference
  end

  return sum
end

def checksum2(sheet)
  sum = 0

  sheet.each do |line|
    line.split(' ').map(&:to_i).combination(2) do |values|
      a = values.max
      b = values.min
      sum += a/b if a%b==0
    end
  end

  return sum
end

class ChecksumTest < Minitest::Test
  def test_checksum
    sheet = [
             "5 1 9 5",
             "7 5 3",
             "2 4 6 8"
            ]
    assert_equal 18, checksum(sheet)
  end

  def test_checksum_2
    sheet = [
              "5 9 2 8",
              "9 4 7 3",
              "3 8 6 5"
            ]
    assert_equal 9, checksum2(sheet)
  end
end

input = File.readlines('input.txt')

puts "Part 1:"
puts checksum(input)
puts "Part 2:"
puts checksum2(input)
