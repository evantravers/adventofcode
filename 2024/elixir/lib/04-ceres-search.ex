defmodule Advent2024.Day4 do
  @moduledoc "https://adventofcode.com/2024/day/4"
  def setup do
    with {:ok, file} <- File.read("../input/4") do
      file
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn ({str, y}, map) ->
        str
        |> String.graphemes
        |> Enum.with_index
        |> Enum.reduce(map, fn({char, x}, map) ->
          Map.put(map, {x, y}, String.to_atom(char))
        end)
      end)
    end
  end

  def xmas?([x, m, a, s], map) do
    Map.get(map, x) == :X &&
    Map.get(map, m) == :M &&
    Map.get(map, a) == :A &&
    Map.get(map, s) == :S
  end

  def generate_directions({x, y}) do
    [
      [{x, y}, {x+1, y}, {x+2, y}, {x+3, y}], # right
      [{x, y}, {x-1, y}, {x-2, y}, {x-3, y}], # left
      [{x, y}, {x, y+1}, {x, y+2}, {x, y+3}], # up
      [{x, y}, {x, y-1}, {x, y-2}, {x, y-3}], # down
      [{x, y}, {x+1, y+1}, {x+2, y+2}, {x+3, y+3}], # up right
      [{x, y}, {x-1, y+1}, {x-2, y+2}, {x-3, y+3}], # up left
      [{x, y}, {x+1, y-1}, {x+2, y-2}, {x+3, y-3}], # down right
      [{x, y}, {x-1, y-1}, {x-2, y-2}, {x-3, y-3}], # down left
    ]
  end

  def check_all_directions(coord, map) do
    coord
    |> generate_directions
    |> Enum.count(&xmas?(&1, map))
  end

  def p1(map) do
    map
    |> Map.keys
    |> Enum.filter(fn coord -> Map.get(map, coord) == :X end) # what if we only checked x?
    |> Enum.map(&check_all_directions(&1, map))
  end
  def p2(_i), do: nil
end
