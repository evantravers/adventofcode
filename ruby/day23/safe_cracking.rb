require 'minitest/autorun'
require 'pry'

class Computer
  REGISTERS = ['a', 'b', 'c', 'd']

  def initialize
    @a, @b, @c, @d = 0, 0, 0, 0
    @instruction_pointer = 0
    @instruction_set     = Array.new
  end

  def inc register
    value = instance_variable_get "@#{register}"
    instance_variable_set "@#{register}", value + 1
  end

  def dec register
    value = instance_variable_get "@#{register}"
    instance_variable_set "@#{register}", value - 1
  end

  def cpy src, dst
    src = evaluate_argument src

    instance_variable_set "@#{dst}", src
  end

  def jnz test, offset
    test   = evaluate_argument test
    offset = evaluate_argument offset

    # this is adjusted because of the instruction pointer advance in `read`
    offset = offset.to_i - 1

    if test != 0
      @instruction_pointer += offset
    end
  end

  def tgl offset
    offset       = evaluate_argument offset
    instruction  = @instruction_set[@instruction_pointer + offset]

    method, args = extract_args instruction

    if args.size == 1
      if method == "inc"
        method = "dec"
      else
        method = "inc"
      end
    elsif args.size == 2
      if method == "jnz"
        method = "cpy"
      else
        method = "jnz"
      end
    end

    new_instruction = "#{method} #{args.join ' '}"
    @instruction_set[@instruction_pointer + offset] = new_instruction
  end

  def inspect
    puts "P: #{@instruction_pointer}"
    puts "I: #{@instruction_set[@instruction_pointer]}"
    puts "STATE:"
    puts "========"
    puts "A: #{@a}"
    puts "B: #{@b}"
    puts "C: #{@c}"
    puts "D: #{@d}"
    puts "========"
  end

  def load instructions
    if instructions.match(/\.txt/)
      instructions = File.readlines(instructions)
    else
      instructions = instructions.split(/\n/).reject(&:empty?)
    end
    @instruction_set = instructions.map { |line| line.strip }
  end

  def execute
    while @instruction_pointer < @instruction_set.length
      read @instruction_set[@instruction_pointer]
    end

    return @a
  end

  private

  def read line
    method, args = extract_args line
    send(method, *args)

    @instruction_pointer += 1
  end

  def extract_args(line)
    args = line.scan(/[\w\d-]+/)
    method = args.shift

    return method, args
  end

  def evaluate_argument arg
    if REGISTERS.include? arg
      instance_variable_get "@#{arg}"
    else
      arg.to_i
    end
  end
end

class TestTgl < Minitest::Test
  def test_one_arg
    """
    For one-argument instructions, inc becomes dec, and all other
    one-argument instructions become inc.
    """
    instructions =
    """
    cpy 2 a
    tgl a
    tgl a
    tgl a
    cpy 1 a
    dec a
    dec a
    """
    computer = Computer.new
    computer.load(instructions)
    binding.pry
    puts computer
  end

  def test_two_arg
    """
    For two-argument instructions, jnz becomes cpy, and all other
    two-instructions become jnz.
    """
  end
  def test_out_of_bounds
    """
    If an attempt is made to toggle an instruction outside the
    program, nothing happens.
    """
  end
  def test_invalid
    """
    If toggling produces an invalid instruction (like cpy 1 2) and
    an attempt is later made to execute that instruction, skip it
    instead.
    """
  end
  def test_tgl_itself
    """
    If tgl toggles itself (for example, if a is 0, tgl a would
    target itself and become inc a), the resulting instruction is
    not executed until the next time it is reached.
    """
  end
end

class TestComputer < Minitest::Test
  def test_sample_data
    computer = Computer.new
    computer.load "test.txt"
    assert_equal 3, computer.execute
  end
end
