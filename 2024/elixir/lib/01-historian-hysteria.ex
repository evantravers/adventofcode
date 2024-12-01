defmodule Advent2024.Day1 do
  @moduledoc "https://adventofcode.com/2024/day/1"

  def setup do
    with {:ok, file} <- File.read("../input/01") do
      file
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
  end

  @doc """
  iex> p1()
  23
  """
  def p1([list_1, list_2] = _input) do
    for left <- list_1, right <- list_2 do abs(left - right) end
    |> Enum.sum
  end
  def p2(_i), do: nil
end
