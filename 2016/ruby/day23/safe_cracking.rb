require 'minitest/autorun'
require 'pry'

class Computer
  REGISTERS = ['a', 'b', 'c', 'd']

  def initialize
    @a, @b, @c, @d = 0, 0, 0, 0
    @instruction_pointer = 0
    @instruction_set     = Array.new
  end

  def set_register id, val
    instance_variable_set "@#{id}", val
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

    if is_a_register? dst
      instance_variable_set "@#{dst}", src
    end
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
    target       = @instruction_pointer + offset
    return nil if target < 0 or target > @instruction_set.size - 1

    instruction  = @instruction_set[target]

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

  def load instructions, regs: {}
    if instructions.match(/\.txt/)
      instructions = File.readlines(instructions).map(&:strip)
    else
      instructions = instructions.split(/\n/).map(&:strip).reject(&:empty?)
    end
    @instruction_set = instructions

    unless regs.empty?
      regs.each do |reg|
        set_register reg.first, reg.last
      end
    end
  end

  def execute(instrument: false)
    while @instruction_pointer < @instruction_set.length
      puts self.inspect if instrument
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

  def is_a_register? arg
    REGISTERS.include? arg
  end

  def evaluate_argument arg
    if is_a_register? arg
      instance_variable_get "@#{arg}"
    else
      arg.to_i
    end
  end
end

class TestTgl < Minitest::Test
  def test_one_arg
    # For one-argument instructions, inc becomes dec, and all other
    # one-argument instructions become inc.
    instructions =
      """
      cpy 1 a
      tgl 1
      dec a
      tgl 1
      inc a
      """
    computer = Computer.new
    computer.load(instructions)
    assert_equal 1, computer.execute
  end

  def test_two_arg_and_invalid
    # For two-argument instructions, jnz becomes cpy, and all other
    # two-instructions become jnz.

    # If toggling produces an invalid instruction (like cpy 1 2) and
    # an attempt is later made to execute that instruction, skip it
    # instead.
    instructions =
      """
      cpy 1 a
      tgl 1
      jnz a 1
      tgl 1
      cpy 1 a
      """
    computer = Computer.new
    computer.load(instructions)
    assert_equal 1, computer.execute
  end

  def test_out_of_bounds
    # If an attempt is made to toggle an instruction outside the
    # program, nothing happens.
    instructions =
      """
      cpy 1 a
      tgl 7
      cpy 2 a
      """
    computer = Computer.new
    computer.load(instructions)
    assert_equal 2, computer.execute
  end

  def test_tgl_itself
    # If tgl toggles itself (for example, if a is 0, tgl a would
    # target itself and become inc a), the resulting instruction is
    # not executed until the next time it is reached.
    instructions =
      """
      cpy 1 a
      tgl 0
      """
    computer = Computer.new
    computer.load(instructions)
    assert_equal 1, computer.execute
  end
end

class TestComputer < Minitest::Test
  def test_sample_data
    computer = Computer.new
    computer.load "test.txt"
    assert_equal 3, computer.execute
  end
end

puts "Part I:"
computer = Computer.new
computer.load "input.txt", regs: {a: 7}
puts computer.execute

puts "Part II:"
computer = Computer.new
computer.load "input.txt", regs: {a: 12}
puts computer.execute
