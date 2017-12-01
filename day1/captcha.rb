require 'minitest/autorun'

def captcha(num)
  sum = 0

  numbers = num.to_s.split.map(&:to_i)
end

class CaptchaTest < Minitest::Test
  def test_1
    assert_equal captcha(1122), 3
  end

  def test_2
    assert_equal captcha(1111), 4
  end

  def test_3
    assert_equal captcha(1234), 0
  end

  def test_4
    assert_equal captcha(91212129), 9
  end
end
