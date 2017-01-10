require 'pry'
require 'minitest/autorun'

def dragon a
  b = a.clone
  b.reverse!
  b = b.gsub('1', 'a').gsub('0', 'b').gsub('a', '0').gsub('b', '1')
  return a + '0' + b
end

# Test cases
class Test < MiniTest::Test
  def test_1_becomes_100
    assert_equal dragon('1'), '100'
  end

  def test_0_becomes_001
    assert_equal dragon('0'), '001'
  end

  def test_11111_becomes_11111000000
    assert_equal dragon('11111'), '11111000000'
  end

  def test_111100001010_becomes_1111000010100101011110000
    assert_equal dragon('111100001010'), '1111000010100101011110000'
  end
end

