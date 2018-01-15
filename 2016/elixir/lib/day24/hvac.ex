defmodule Advent2016.Day24 do
  @moduledoc """
  You extract the duct layout for this area from some blueprints you acquired
  and create a map with the relevant locations marked (your puzzle input). 0 is
  your current location, from which the cleaning robot embarks; the other
  numbers are (in no particular order) the locations the robot needs to visit
  at least once each. Walls are marked as #, and open passages are marked as ..
  Numbers behave like open passages.
  """

  def build_map({str, y_index}, map) do
    str
    |> String.split("", trim: true)
    |> Enum.with_index
    |> Enum.reduce([], fn {val, x_index}, result ->
      case val do
        "#" -> result
        "." -> [{true, x_index, y_index}|result]
          _ -> [{String.to_integer(val), x_index, y_index}|result]
      end
    end)
    |> MapSet.new()
    |> MapSet.union(map)
  end

  def load_input(file \\ "input.txt") do
    {:ok, file} = File.read("#{__DIR__}/#{file}")

    file
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.reduce(MapSet.new, &build_map(&1, &2))
  end

  def p1, do: nil
  def p2, do: nil
end
