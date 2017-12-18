defmodule Advent2017.Day18 do
  @doc ~S"""
  snd X plays a sound with a frequency equal to the value of X.
  """
  def snd(state, x) do
    Map.put(state, :snd, e(state, x))
  end

  @doc ~S"""
  set X Y sets register X to the value of Y.
  """
  def set(state, x, y) do
    Map.put(state, a(x), e(state, y))
  end

  @doc ~S"""
  add X Y increases register X by the value of Y.
  """
  def add(state, x, y) do
    Map.put(state, a(x), state[a(x)] + e(state, y))
  end

  @doc ~S"""
  mul X Y sets register X to the result of multiplying the value contained in
  register X by the value of Y.
  """
  def mul(state, x, y) do
    Map.put(state, a(x), state[a(x)] * e(state, y))
  end

  @doc ~S"""
  mod X Y sets register X to the remainder of dividing the value contained in
  register X by the value of Y (that is, it sets X to the result of X modulo
  Y).
  """
  def mod(state, x, y) do
    Map.put(state, a(x), rem(state[a(x)], e(state,y)))
  end

  @doc ~S"""
  rcv X recovers the frequency of the last sound played, but only when the
  value of X is not zero. (If it is zero, the command does nothing.)
  """
  def rcv(state, x) do
    if e(state, x) != 0 do
      state[:snd]
    end
  end

  @doc ~S"""
  jgz X Y jumps with an offset of the value of Y, but only if the value of X
  is greater than zero. (An offset of 2 skips the next instruction, an offset
  of -1 jumps to the previous instruction, and so on.)
  """
  def jgz(state, x, y) do
    if e(state, x) > 0 do
      e(state, y)
    end
  end

  def a(str), do: String.to_atom(str)

  @doc ~S"""
  e evaluates a variable by the stack. If there's a register, it returns that.
  """
  def e(state, var) do
    cond do
      Enum.member?(state.keys, a(var)) ->
        state[a(var)]
      true ->
        String.to_integer(var)
    end
  end
end
