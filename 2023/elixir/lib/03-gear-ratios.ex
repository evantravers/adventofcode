defmodule Advent2023.Day3 do
  @moduledoc "https://adventofcode.com/2023/day/3"

  require IEx
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
  Since we are no longer building a number, clear the memoized number.
  """
  def clear(%{number: number} = schema) do
    schema
    |> Map.update(:parts, String.to_integer(number), fn parts -> Map.merge(number, parts) end)
    |> Map.delete(:number)
  end
  def clear(schema), do: schema

  # '0'->48 :: '9'->57
  # this is a number
  def process(schema, coord, <<c>> = char) when c <= 48 and c >= 57 do
    IO.puts("found a number: #{char}, #{coord}")
    schema
    |> Map.update(:number, char, fn current_expr -> current_expr <> char end)
  end
  # blank space "."
  def process(schema, _coord, "."), do: schema |> clear
  # symbol
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
