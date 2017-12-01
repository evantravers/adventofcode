require 'minitest/autorun'
require 'pry'

class String
  def swap_position x, y
    x, y = x.to_i, y.to_i

    self[x], self[y] = self[y], self[x]
    self
  end

  def swap_letter x, y
    loc_x, loc_y = self.rindex(x), self.rindex(y)
    self.swap_position(loc_x, loc_y)
  end

  def rotate_steps dir, x
    dir, x = dir.to_sym, x.to_i

    x = x * -1 if dir == :right

    self.split('').rotate(x).join
  end

  def rotate_position x
    index_of_char = self.rindex(x)
    index_of_char += 1 if index_of_char > 3
    index_of_char += 1
    dir = :right
    self.rotate_steps dir, index_of_char
  end

  def reverse_positions x, y
    x, y = x.to_i, y.to_i

    self[x..y] = self[x..y].reverse
    self
  end

  def move_position x, y
    x, y = x.to_i, y.to_i

    moving = self.slice!(x)
    self.insert(y, moving)
  end
end

class Scrambler
  COMMANDS = {
    swap_position: /swap position (\d) with position (\d)/,
    swap_letter: /swap letter (\w) with letter (\w)/,
    rotate_steps: /rotate (\w+) (\d) step/,
    rotate_position: /rotate based on position of letter (\w)/,
    reverse_positions: /reverse positions (\d) through (\d)/,
    move_position: /move position (\d) to position (\d)/
  }

  def initialize instructions_file
    @instructions = File.readlines(instructions_file).map { |l| l.strip }
  end

  def encode str
    iterations = [str]
    @instructions.each do |instruction|
      command = COMMANDS.find { |name, pattern| instruction.match pattern }
      name    = command.first

      args    = instruction.match(command.last).captures

      str     = str.send(name, *args)
      iterations << str
    end
    return str
  end

  def decode str
    str.split('').permutation.find { |pass| self.encode(pass.join) == str }.join
  end
end

class TestString < Minitest::Test
  def test_swap_position
    assert_equal 'ebcda', 'abcde'.swap_position(4, 0)
    assert_equal 'adcbefg', 'abcdefg'.swap_position(1, 3)
    assert_equal 'gbcdefa', 'abcdefg'.swap_position(0, 6)
  end

  def test_swap_letter
    assert_equal 'edcba', 'ebcda'.swap_letter('d', 'b')
    assert_equal 'ahcdefgb', 'abcdefgh'.swap_letter('b', 'h')
  end

  def test_reverse_positions
    assert_equal 'abcde', 'edcba'.reverse_positions(0, 4)
    assert_equal 'aedcbfgh', 'abcdefgh'.reverse_positions(1, 4)
  end

  def test_rotate_steps
    assert_equal 'bcdea', 'abcde'.rotate_steps(:left, 1)
    assert_equal 'habcdefg', 'abcdefgh'.rotate_steps(:right, 1)
  end

  def test_rotate_position
    assert_equal 'ecabd', 'abdec'.rotate_position('b')
    assert_equal 'decab', 'ecabd'.rotate_position('d')
    assert_equal 'abcdefgh', 'abcdefgh'.rotate_position('g')
    assert_equal 'efghabcd', 'abcdefgh'.rotate_position('d')
  end

  def test_move_position
    assert_equal 'bdeac', 'bcdea'.move_position(1, 4)
    assert_equal 'dabcefgh', 'abcdefgh'.move_position(3, 0)
  end
end

class TestScrambler < MiniTest::Test
  def test_from_website
    s = Scrambler.new('test.txt')
    assert_equal 'decab', s.encode('abcde')
    assert_equal 'abcde', s.decode('decab'), "It should find the reverse"
  end

  def test_input
    s = Scrambler.new('input.txt')
    assert_equal 'abcdefgh', s.decode('ghfacdbe'),
      "Should be able to undo the encoding"
  end
end

s = Scrambler.new('input.txt')
puts "Part 1:"
puts s.encode('abcdefgh')
puts "Part 2:"
puts s.decode('fbgdceah')
