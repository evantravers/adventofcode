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
        schema
        |> clear
        |> process({x, y}, char)
      end)
    end)
    |> clear
  end

  def setup do
    with {:ok, file} <- File.read("../input/3") do
      file |> setup_from_string
    end
  end

  @doc """
  Should handle the "expression" of the parser completing number.

  iex> clear(%{number: {"123", [{0,0}, {1, 0}, {2, 0}]}})
  %{parts: %{123 => [{0,0}, {1, 0}, {2, 0}]}}
  """
  def clear(%{number: number, number_coords: coords} = schema) do
    id = String.to_integer(number)
    schema
    |> Map.update(:parts, %{id => coords}, &Map.put(&1, id, coords))
    |> Map.delete(:number)
  end
  def clear(schema), do: schema

  @doc """
  Should handle the "tokens" being passed into it, if you are thinking of it as
  a parser.

  iex> process(%{}, {0, 0}, "0")
  %{number: "0"}

  iex> process(%{}, {0, 0}, "9")
  %{number: "9"}

  iex> %{}
  ...> |> process({0, 1}, "1")
  ...> |> process({0, 2}, "2")
  %{number: "12"}

  iex> process(%{}, {0, 0}, ".")
  %{}

  iex> process(%{}, {0, 0}, "*")
  %{symbols: [{0,0}]}
  """
  def process(schema, coord, <<c>> = char) when c >= 48 and c <= 57 do
    schema
    |> Map.update(:number, char, fn expr -> expr <> char end)
    |> Map.update(:number_coords, [coord], fn coords -> [coord|coords] end)
  end
  def process(schema, _coord, "."), do: schema |> clear
  def process(schema, coord, _char) do
    schema
    |> clear
    |> Map.update(:symbols, [coord], fn coords -> [coord|coords] end)
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
    |> IO.inspect
  end

  def p2(_i), do: nil
end
