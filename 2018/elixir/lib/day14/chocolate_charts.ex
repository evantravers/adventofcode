defmodule Advent2018.Day14 do
  @moduledoc """
  https://adventofcode.com/2018/day/14

  I think the most efficient way to store these is to store them backwards.

  Starting position is 3, 7... but I'm going to save them "backwards" so we can
  all concat on the head.
  """

  @input 793031

  def play({recipes, first, second} \\ {[7, 3], 0, 1}) do
    {recipes, first, second}
  end

  def number_to_list(number) do
    number
    |> Integer.to_string
    |> String.graphemes
    |> Enum.reverse
    |> Enum.map(&String.to_integer/1)
  end

  def at(list, position), do: Enum.at(list, Enum.count(list) - 1 - position)

  def p1 do
    [7, 3] |> at(0)
  end

  def p2, do: nil
end

