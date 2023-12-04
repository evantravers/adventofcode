defmodule Advent2023.Day3 do
  @moduledoc "https://adventofcode.com/2023/day/3"

  def setup_from_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn({row, y}, schema) ->
      row
      |> clear
      |> String.codepoints
      |> Enum.with_index
      |> Enum.reduce(schema, fn({char, x}, schema) ->
        schema
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

  iex> clear(%{expr: {"123", [{0,0}, {1, 0}, {2, 0}]}})
  %{parts: %{123 => [{0,0}, {1, 0}, {2, 0}]}}
  """
  def clear(%{expr: {number, coords}} = schema) do
    id = String.to_integer(number)

    schema
    |> Map.update(:parts, %{id => coords}, &Map.put(&1, id, coords))
    |> Map.delete(:expr)
  end
  def clear(schema), do: schema

  @doc """
  Should handle the "tokens" being passed into it, if you are thinking of it as
  a parser.

  iex> process(%{}, {0, 0}, "0")
  %{expr: {"0", [{0, 0}]}}

  iex> process(%{}, {0, 0}, "9")
  %{expr: {"9", [{0, 0}]}}

  iex> %{}
  ...> |> process({0, 0}, "1")
  ...> |> process({1, 0}, "2")
  %{expr: {"12", [{1, 0}, {0, 0}]}}

  iex> process(%{}, {0, 0}, ".")
  %{}

  iex> process(%{}, {0, 0}, "*")
  %{symbols: [{0,0}]}
  """
  def process(schema, coord, <<c>> = char) when c >= 48 and c <= 57 do
    {number, coords} = Map.get(schema, :expr, {"", []})

    Map.put(schema, :expr, {number <> char, [coord|coords]})
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
