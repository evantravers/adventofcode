defmodule Advent2025.Day2 do
  @moduledoc """
  https://adventofcode.com/2025/day/2

  I think the approach here is going to be to build a sieve. Starting from min
  iterate up to max. If you find a repeat number, mark all the multiples up to
  max as also invalid.

  Then I can merely ask how which "fake IDs" are included in the ranges.
  """

  def setup do
  end

  def p1(_i), do: nil
  def p2(_i), do: nil
end
