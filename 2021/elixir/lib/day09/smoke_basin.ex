defmodule Advent2021.Day9 do
  @moduledoc "https://adventofcode.com/2021/day/9"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt"), do: setup_string(file)
  end

  def setup_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn({row, y}, map) ->
      row
      |> String.codepoints
      |> Enum.with_index
      |> Enum.reduce(map, fn({char, x}, map) ->
        Map.put(map, {x, y}, String.to_integer(char))
      end)
    end)
  end

  def low_point?({{x, y}, height}, map) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.all?(fn(coord) ->
      Map.get(map, coord) > height
    end)
  end

  @doc """
      iex> "2199943210
      ...>3987894921
      ...>9856789892
      ...>8767896789
      ...>9899965678"
      ...> |> setup_string
      ...> |> p1
      15
  """
  def p1(map) do
    map
    |> Enum.filter(&low_point?(&1, map))
    |> Enum.map(fn({_coord, height}) -> height + 1 end)
    |> Enum.sum
  end

  def p2(_i), do: nil
end
