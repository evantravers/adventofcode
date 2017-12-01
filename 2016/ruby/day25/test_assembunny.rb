require 'minitest/autorun'
require_relative 'assembunny.rb'

class TestAssembunny < Minitest::Test
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

  def test_out
    instructions =
      """
      out 1
      out 0
      out 1
      out 0
      """
    computer = Computer.new
    computer.load(instructions)
    computer.execute
    assert_equal [1, 0, 1, 0], computer.tape
  end

  def test_out2
    instructions =
      """
      cpy 1 a
      inc a
      inc a
      out a
      """
    computer = Computer.new
    computer.load(instructions)
    computer.execute
    assert_equal [3], computer.tape
  end
end
