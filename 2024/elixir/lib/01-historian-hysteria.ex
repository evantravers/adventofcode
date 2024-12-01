defmodule Advent2024.Day1 do
  @moduledoc "https://adventofcode.com/2024/day/1"

  def setup do
    with {:ok, file} <- File.read("../input/01") do
      file |> setup_string
    end
  end

  def setup_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(fn(str) ->
      str
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip
    |> Enum.map(fn(tuple) ->
      tuple
      |> Tuple.to_list
      |> Enum.sort
    end)
  end

  @doc """
  iex> "3   4
  ...>4   3
  ...>2   5
  ...>1   3
  ...>3   9
  ...>3   3"
  ...> |> setup_string
  ...> |> p1
  11
  """
  def p1([list_1, list_2] = _input) do
    Enum.zip(list_1, list_2)
    |> Enum.map(fn {a, b} ->
      abs(a - b)
    end)
    |> Enum.sum
  end
  def p2(_i), do: nil
end
