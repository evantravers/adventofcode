defmodule Advent2023.Day10 do
  @moduledoc "https://adventofcode.com/2023/day/10"

  def setup do
    with {:ok, file} <- File.read("../input/10") do
      file
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn ({row, y}, map) ->
        row
        |> String.codepoints
        |> Enum.with_index
        |> Enum.reduce(map, fn ({char, x}, map) ->
          Map.put(map, {x, y}, char)
        end)
      end)
    end
  end

  def p1(_i), do: nil
  def p2(_i), do: nil
end
