defmodule Advent2020.Day11 do
  @moduledoc "https://adventofcode.com/2020/day/11"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn({str, y}, map) ->
        str
        |> String.graphemes
        |> Enum.with_index
        |> Enum.reduce(map, fn
          ({"L", x}, map) -> Map.put(map, {x, y}, true)
          ({"#", x}, map) -> Map.put(map, {x, y}, false)
          ({".", x}, map) -> map #no-op
        end)
      end)
    end
  end

  def p1(i) do
    i
  end

  def p2(_i), do: nil
end
