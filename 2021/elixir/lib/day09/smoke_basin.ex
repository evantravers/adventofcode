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

  def adjacent({x, y}), do: [ {x - 1, y}, {x + 1, y}, {x, y - 1}, {x, y + 1} ]

  def low_point?({point, height}, map) do
    point
    |> adjacent
    |> Enum.all?(fn(coord) ->
      Map.get(map, coord) > height
    end)
  end

  def basin?(9), do: false
  def basin?(i) when is_integer(i), do: true
  def basin?(_i), do: false

  def find_basin(queue, map, visited \\ MapSet.new())
  def find_basin([], _map, visited), do: visited
  def find_basin([coord|queue], map, visited) do
    find_basin(
      coord
      |> adjacent
      |> Enum.filter(&Map.get(map, &1) |> basin?)
      |> Enum.reject(&Enum.member?(visited, &1))
      |> Kernel.++(queue),
      map,
      MapSet.put(visited, coord)
    )
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

  @doc """
      iex> "2199943210
      ...>3987894921
      ...>9856789892
      ...>8767896789
      ...>9899965678"
      ...> |> setup_string
      ...> |> p2
      1134
  """
  def p2(map) do
    map
    |> Enum.filter(&low_point?(&1, map))
    |> Enum.map(fn(low_point) ->
      low_point
      |> elem(0)
      |> List.wrap
      |> find_basin(map)
      |> Enum.count
    end)
    |> Enum.sort
    |> Enum.reverse
    |> Enum.take(3)
    |> Enum.product
  end
end
