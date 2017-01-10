require 'pry'
require 'minitest/autorun'

def dragon a
  b = a.clone
  b.reverse!
  b = b.gsub('1', 'a').gsub('0', 'b').gsub('a', '0').gsub('b', '1')
  return a + '0' + b
end

def checksum string
  string = string.split('')
  result = ""

  until string.empty?
    chars = string.shift(2)
    if chars.first == chars.last
      result += "1"
    else
      result += "0"
    end
  end

  if result.size.even?
    return checksum(result)
  else
    return result
  end
end

# Test cases
class DragonTest < MiniTest::Test
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

class ChecksumTest < MiniTest::Test
  def test_110010110100
    assert_equal checksum('110010110100'), '100'
  end
end
