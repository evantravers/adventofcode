defmodule Advent2016.Day3 do
  @moduledoc """
  http://adventofcode.com/2016/day/3
  """

  @doc ~S"""
  In a valid triangle, the sum of any two sides must be larger than the
  remaining side.

        iex> triangle?([5, 10, 25])
        false
        iex> triangle?([3, 4, 5])
        true
  """
  def triangle?([a, b, c]) do
    (a + b > c) && (b + c > a) && (c + a > b)
  end

  def load_input_by_rows do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt"), do: file
    |> String.split("\n", trim: true)
    |> Enum.map(fn (sides) ->
      sides
      |> String.split(" ", trim: true)
      |> Enum.map(& String.to_integer &1)
    end)
  end

  def load_input_by_columns do
    load_input_by_rows
    |> List.zip
    |> Enum.map(&Tuple.to_list(&1))
    |> List.flatten
    |> Enum.chunk_every(3)
  end

  def p1 do
    load_input_by_rows
    |> Enum.count(&triangle? &1)
  end

  def p2 do
    load_input_by_columns
    |> Enum.count(&triangle? &1)
  end
end
