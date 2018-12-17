defmodule Advent2018.Day16 do
  @moduledoc "https://adventofcode.com/2018/day/16"
  @doc """
  Addition:

  addr (add register)
  stores into register C the result of adding register A and register B.

  addi (add immediate)
  stores into register C the result of adding register A and value B.

  Multiplication:

  mulr (multiply register)
  stores into register C the result of multiplying register A and register B.

  muli (multiply immediate)
  stores into register C the result of multiplying register A and value B.

  Bitwise AND:

  banr (bitwise AND register)
  stores into register C the result of the bitwise AND of register A and register B.

  bani (bitwise AND immediate)
  stores into register C the result of the bitwise AND of register A and value B.

  Bitwise OR:

  borr (bitwise OR register)
  stores into register C the result of the bitwise OR of register A and register B.

  bori (bitwise OR immediate)
  stores into register C the result of the bitwise OR of register A and value B.

  Assignment:

  setr (set register)
  copies the contents of register A into register C. (Input B is ignored.)

  seti (set immediate)
  stores value A into register C. (Input B is ignored.)

  Greater-than testing:

  gtir (greater-than immediate/register)
  sets register C to 1 if value A is greater than register B.
  Otherwise, register C is set to 0.

  gtri (greater-than register/immediate)
  sets register C to 1 if register A is greater than value B.
  Otherwise, register C is set to 0.

  gtrr (greater-than register/register)
  sets register C to 1 if register A is greater than register B.
  Otherwise, register C is set to 0.

  Equality testing:

  eqir (equal immediate/register)
  sets register C to 1 if value A is equal to register B.
  Otherwise, register C is set to 0.

  eqri (equal register/immediate)
  sets register C to 1 if register A is equal to value B.
  Otherwise, register C is set to 0.

  eqrr (equal register/register)
  sets register C to 1 if register A is equal to register B.
  Otherwise, register C is set to 0.
  """

  def p1, do: nil
  def p2, do: nil
end

