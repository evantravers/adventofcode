defmodule Advent2018.Day16 do
  use Bitwise

  @moduledoc """
  https://adventofcode.com/2018/day/16

  Every instruction consists of four values: an opcode, two inputs (named A and
  B), and an output (named C), in that order. The opcode specifies the behavior
  of the instruction and how the inputs are interpreted. The output, C, is
  always treated as a register.

  In the opcode descriptions below, if something says "value A", it means to
  take the number given as A literally. (This is also called an "immediate"
  value.) If something says "register A", it means to use the number given as A
  to read from (or write to) the register with that number. So, if the opcode
  addi adds register A and value B, storing the result in register C, and the
  instruction addi 0 7 3 is encountered, it would add 7 to the value contained
  by register 0 and store the sum in register 3, never modifying registers 0,
  1, or 2 in the process.
  """

  @doc """
  addr (add register)
  stores into register C the result of adding register A and register B.
  """
  def addr(state, [a, b, c]) do
    Map.put(state, c, Map.get(state, a) + Map.get(state, b))
  end

  @doc """
  addi (add immediate)
  stores into register C the result of adding register A and value B.
  """
  def addi(state, [a, b, c]) do
    Map.put(state, c, Map.get(state, a), b)
  end

  @doc """
  mulr (multiply register)
  stores into register C the result of multiplying register A and register B.
  """
  def mulr(state, [a, b, c]) do
    Map.put(state, c, Map.get(state, a) * Map.get(state, b))
  end

  @doc """
  muli (multiply immediate)
  stores into register C the result of multiplying register A and value B.
  """
  def muli(state, [a, b, c]) do
    Map.put(state, c, Map.get(state, a) * b)
  end

  @doc """
  banr (bitwise AND register)
  stores into register C the result of the bitwise AND of register A and
  register B.
  """
  def banr(state, [a, b, c]) do
    Map.put(state, c, Map.get(state, a) &&& Map.get(state, b))
  end

  @doc """
  bani (bitwise AND immediate)
  stores into register C the result of the bitwise AND of register A and value
  B.
  """
  def bani(state, [a, b, c]) do
    Map.put(state, c, Map.get(state, a) &&& b)
  end

  @doc """
  borr (bitwise OR register)
  stores into register C the result of the bitwise OR of register A and
  register B.
  """
  def banr(state, [a, b, c]) do
    Map.put(state, c, Map.get(state, a) ^^^ Map.get(state, b))
  end

  @doc """
  bori (bitwise OR immediate)
  stores into register C the result of the bitwise OR of register A and value
  B.
  """
  def bani(state, [a, b, c]) do
    Map.put(state, c, Map.get(state, a) ^^^ b)
  end

  @doc """
  setr (set register)
  copies the contents of register A into register C. (Input B is ignored.)
  """
  def setr(state, [a, _, c]) do
    Map.put(state, c, Map.get(state, a))
  end

  @doc """
  seti (set immediate)
  stores value A into register C. (Input B is ignored.)
  """
  def seti(state, [a, _, c]) do
    Map.put(state, c, a)
  end

  @doc """
  gtir (greater-than immediate/register)
  sets register C to 1 if value A is greater than register B.
  Otherwise, register C is set to 0.
  """
  def gtir(state, [a, b, c]) do
    Map.put(state, c,
      if a > Map.get(state, b) do
        1
      else
        0
      end
    )
  end

  @doc """
  gtri (greater-than register/immediate)
  sets register C to 1 if register A is greater than value B.
  Otherwise, register C is set to 0.
  """
  def gtri(state, [a, b, c]) do
    Map.put(state, c,
      if Map.get(state, a) > b do
        1
      else
        0
      end
    )
  end

  @doc """
  gtrr (greater-than register/register)
  sets register C to 1 if register A is greater than register B.
  Otherwise, register C is set to 0.
  """
  def gtrr(state, [a, b, c]) do
    Map.put(state, c,
      if Map.get(state, a) > Map.get(state, b) do
        1
      else
        0
      end
    )
  end

  @doc """
  eqir (equal immediate/register)
  sets register C to 1 if value A is equal to register B.
  Otherwise, register C is set to 0.
  """
  def eqir(state, [a, b, c]) do
    Map.put(state, c,
      if a == Map.get(state, b) do
        1
      else
        0
      end
    )
  end

  @doc """
  eqri (equal register/immediate)
  sets register C to 1 if register A is equal to value B.
  Otherwise, register C is set to 0.
  """
  def eqri(state, [a, b, c]) do
    Map.put(state, c,
      if Map.get(state, a) == b do
        1
      else
        0
      end
    )
  end

  @doc """
  eqrr (equal register/register)
  sets register C to 1 if register A is equal to register B.
  Otherwise, register C is set to 0.
  """
  def eqrr(state, [a, b, c]) do
    Map.put(state, c,
      if Map.get(state, a) == Map.get(state, b) do
        1
      else
        0
      end
    )
  end

  def p1, do: nil
  def p2, do: nil
end

