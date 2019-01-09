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

  def get(map, index) do
    Map.get(map, at(map, index))
  end

  def at(map, index), do: Integer.mod(index, Enum.count(map))

  def add(map, num) do
    number =
      num
      |> Integer.to_string
      |> String.graphemes
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index(Enum.count(map))

    number
    |> Enum.map(fn({val, ind}) -> {ind, val} end)
    |> Enum.into(map)
  end

  def print({map, first, second}) do
    map
    |> Map.update!(at(map, first), & "(#{&1})")
    |> Map.update!(at(map, second), & "[#{&1}]")
    |> Enum.to_list
    |> List.keysort(0)
    |> Enum.map(&elem(&1, 1))
    |> Enum.join
  end

  def p1 do
    [7, 3] |> at(0)
  end

  def p2, do: nil
end

