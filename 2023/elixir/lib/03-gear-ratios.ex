defmodule Advent2023.Day3 do
  @moduledoc "https://adventofcode.com/2023/day/3"

  def setup_from_string(str) do
    str
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

  def setup do
    with {:ok, file} <- File.read("../input/3") do
      file |> setup_from_string
    end
  end

  @doc """
  iex> "467..114..
  ...>...*......
  ...>..35..633.
  ...>......#...
  ...>617*......
  ...>.....+.58.
  ...>..592.....
  ...>......755.
  ...>...$.*....
  ...>.664.598.."
  ...> |> setup_from_string
  ...> |> p1
  4361
  """
  def p1(schematic) do
    schematic
  end

  def p2(_i), do: nil
end
