defmodule Advent2016.Day3 do
  @moduledoc """
  http://adventofcode.com/2016/day/3
  """

  @doc ~S"""
  In a valid triangle, the sum of any two sides must be larger than the
  remaining side.

        iex> possible([5, 10, 25])
        false
        iex> possible([3, 4, 5])
        true
  """
  def possible(sides) do
    Enum.all?(sides, & &1 < Enum.sum(List.delete(sides, &1)))
  end

  def p1, do: nil
  def p2, do: nil
end
