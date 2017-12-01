require 'minitest/autorun'

def captcha(num)
  sum = 0

  numbers = num.to_s.split('').map(&:to_i)

  # hacky circular array
  numbers.push numbers.first

  numbers.each_cons(2) do |a, b|
    if a == b
      sum += a
    end
  end

  return sum
end

class CaptchaTest < Minitest::Test
  def test_1
    assert_equal 3, captcha(1122)
  end

  def test_2
    assert_equal 4, captcha(1111)
  end

  def test_3
    assert_equal 0, captcha(1234)
  end

  def test_4
    assert_equal 9, captcha(91212129)
  end
end

input = File.readlines('input.txt').first.to_i
puts captcha(input)
