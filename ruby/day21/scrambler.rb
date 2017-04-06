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
  SWAP_POSITION = /swap position (\d) with position (\d)/
  SWAP_LETTER = /swap letter (\w) with letter (\w)/
  ROTATE_STEPS = /rotate (\w+) (\d) step/
  ROTATE_POSITION = /rotate based on position of letter (\w)/
  REVERSE_POSITIONS = /reverse positions (\d) through (\d)/
  MOVE_POSITION = /move position (\d) to position (\d)/

  def initialize instructions_file
    @instructions = File.readlines(instructions_file).map { |l| l.strip }
  end

  def encode str
    @instructions.each do |command|
      case
        when command.match(SWAP_POSITION)
          args = command.scan(SWAP_POSITION)
          args.flatten!.map!(&:to_i)
          str  = str.swap_position(*args)
        when command.match(SWAP_LETTER)
          args = command.scan(SWAP_LETTER)
          args.flatten!
          str  = str.swap_letter(*args)
        when command.match(ROTATE_STEPS)
          args = command.scan(ROTATE_STEPS)
          args.flatten!
          str  = str.rotate_steps(args.first.to_sym, args.last.to_i)
        when command.match(ROTATE_POSITION)
          args = command.scan(ROTATE_POSITION)
          args.flatten!
          str = str.rotate_position(*args)
        when command.match(REVERSE_POSITIONS)
          args = command.scan(REVERSE_POSITIONS)
          args.flatten!.map!(&:to_i)
          str  = str.reverse_positions(*args)
        when command.match(MOVE_POSITION)
          args = command.scan(MOVE_POSITION)
          args.flatten!.map!(&:to_i)
          str  = str.move_position(*args)
        else
          puts "ERROR!"
          exit
      end
    end

    return str
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
