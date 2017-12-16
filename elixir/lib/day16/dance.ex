defmodule Advent2017.Day16 do
  @doc """
  Spin, written sX, makes X programs move from the end to the front, but
  maintain their order otherwise. (For example, s3 on abcde produces cdeab).

      iex> Advent2017.Day16.s("abcde", 3)
      "cdeab"
  """
  def s(string, count) do
  end

  @doc """
  Exchange, written xA/B, makes the programs at positions A and B swap places.

      iex> Advent2017.Day16.x("abcde", 0, 2)
      "cbade"
  """
  def x(string, pos1, pos2) do
  end

  @doc """
  Partner, written pA/B, makes the programs named A and B swap places.

      iex> Advent2017.Day16.p("abcde", "b", "d")
      "adcbe"
  """
  def p(string, a, b) do
  end
end
