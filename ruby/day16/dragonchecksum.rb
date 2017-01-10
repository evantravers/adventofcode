require 'pry'
require 'minitest/autorun'

class Disk
  def initialize input, size
    @input = input
    @size  = size
  end

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

  def solve
    random_data = @input
    until random_data.size >= @size
      random_data = dragon random_data
    end

    # trim to size
    random_data = random_data[0...@size]

    checksum(random_data)
  end
end

# Test cases
class DiskTest < MiniTest::Test
  def setup
    @disk = Disk.new('10000', 20)
  end

  def test_1_becomes_100
    assert_equal @disk.dragon('1'), '100'
  end

  def test_0_becomes_001
    assert_equal @disk.dragon('0'), '001'
  end

  def test_11111_becomes_11111000000
    assert_equal @disk.dragon('11111'), '11111000000'
  end

  def test_111100001010_becomes_1111000010100101011110000
    assert_equal @disk.dragon('111100001010'), '1111000010100101011110000'
  end

  def test_110010110100
    assert_equal @disk.checksum('110010110100'), '100'
  end

  def test_disk_solve
    assert_equal @disk.solve, '01100'
  end
end

puts Disk.new('10111100110001111', 272).solve
