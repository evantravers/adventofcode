require 'minitest/autorun'

def captcha(num)
  sum = 0

  numbers = num.to_s.split('').map(&:to_i)

  size = numbers.size

  numbers.each_with_index do |n, i|
    possible_match = numbers[(i+1)%size]
    if n == possible_match
      sum += n
    end
  end

  return sum
end

def captcha2(num)
  sum = 0

  numbers = num.to_s.split('').map(&:to_i)

  size   = numbers.size
  offset = size/2

  numbers.each_with_index do |n, i|
    possible_match = numbers[(i+offset)%size]
    if n == possible_match
      sum += n
    end
  end

  return sum
end

class CaptchaTest < Minitest::Test
  def test_part_one
    assert_equal 3, captcha(1122)
    assert_equal 4, captcha(1111)
    assert_equal 0, captcha(1234)
    assert_equal 9, captcha(91212129)
  end

  def test_part_two
    assert_equal 6,  captcha2(1212)
    assert_equal 0,  captcha2(1221)
    assert_equal 4,  captcha2(123425)
    assert_equal 12, captcha2(123123)
    assert_equal 4,  captcha2(12131415)
  end
end

input = File.readlines('input.txt').first.to_i

puts "Part 1:"
puts captcha(input)

puts "Part 2:"
puts captcha2(input)
