require 'minitest/autorun'

class String
  def swap_position x, y
    self[x], self[y] = self[y], self[x]
    self
  end

  def swap_letter x, y
    loc_x, loc_y = self.rindex(x), self.rindex(y)
    self.swap_position(loc_x, loc_y)
  end

  def rotate_steps dir, x
    x = x * -1 if dir == :right
    self.split('').rotate(x).join
  end

  def rotate_position x
    index_of_char = self.rindex(x)
    index_of_char += 1 if index_of_char > 3
    index_of_char += 1
    self.rotate_steps :right, index_of_char
  end

  def reverse_positions x, y
    self[x..y] = self[x..y].reverse
  end

  def move_position x, y
    moving = self.slice!(x)
    self.insert(y, moving)
  end
end

class Scrambler
  def initialize instructions_file
    @instructions = File.readlines(instructions_file).map { |l| l.strip }
  end

  def encode str
    str
  end
end

class TestString < Minitest::Test
  def test_swap_position
    assert_equal 'ebcda', 'abcde'.swap_position(4, 0)
  end

  def test_swap_letter
    assert_equal 'edcba', 'ebcda'.swap_letter('d', 'b')
  end

  def test_reverse_positions
    assert_equal 'abcde', 'edcba'.reverse_positions(0, 4)
  end

  def test_rotate_steps
    assert_equal 'bcdea', 'abcde'.rotate_steps(:left, 1)
  end

  def test_rotate_position
    assert_equal 'ecabd', 'abdec'.rotate_position('b')
  end

  def test_move_position
    assert_equal 'bdeac', 'bcdea'.move_position(1, 4)
  end
end

class TestScrambler < MiniTest::Test
  def test_from_website
    s = Scrambler.new('test.txt')
    assert_equal 'decab', s.encode('abcde')
  end
end
