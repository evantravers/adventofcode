defmodule Advent2017.Day18 do
  @doc ~S"""
  snd X plays a sound with a frequency equal to the value of X.
  """

  @doc ~S"""
  set X Y sets register X to the value of Y.
  """

  @doc ~S"""
  add X Y increases register X by the value of Y.
  """

  @doc ~S"""
  mul X Y sets register X to the result of multiplying the value contained in
  register X by the value of Y.
  """

  @doc ~S"""
  mod X Y sets register X to the remainder of dividing the value contained in
  register X by the value of Y (that is, it sets X to the result of X modulo
  Y).
  """

  @doc ~S"""
  rcv X recovers the frequency of the last sound played, but only when the
  value of X is not zero. (If it is zero, the command does nothing.)
  """

  @doc ~S"""
  jgz X Y jumps with an offset of the value of Y, but only if the value of X
  is greater than zero. (An offset of 2 skips the next instruction, an offset
  of -1 jumps to the previous instruction, and so on.)
  """
end
