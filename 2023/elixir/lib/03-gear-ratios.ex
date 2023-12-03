defmodule Advent2023.Day3 do
  @moduledoc "https://adventofcode.com/2023/day/3"

  def setup do
    with {:ok, file} <- File.read("../input/3") do
      file
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn({row, y}, schema) ->
        row
        |> String.codepoints
        |> Enum.with_index
        |> Enum.reduce(schema, fn({char, x}, schema) ->
          Map.put(schema, {x, y}, char)
          # process(schema, {x, y}, char)
        end)
      end)
    end
  end

  def p1(schematic) do
    schematic
  end

  def p2(_i), do: nil
end
