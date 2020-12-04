defmodule Advent2020.Day3 do
  @moduledoc "https://adventofcode.com/2020/day/3"
  @behaviour Advent

  def setup do
    with {:ok, str} <- File.read("#{__DIR__}/input.txt") do
      setup_string(str)
    end
  end

  def setup_string(str) do
    map =
      str
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn({line, y}, map) ->
        line
        |> String.graphemes
        |> Enum.with_index
        |> Enum.reduce(map, fn({char, x}, map) ->
          Map.put(map, {x, y}, tree?(char))
        end)
      end)

    height =
      map
      |> Map.keys
      |> Enum.map(&elem(&1, 1))
      |> Enum.max

    width =
      map
      |> Map.keys
      |> Enum.map(&elem(&1, 0))
      |> Enum.max

    map
    |> Map.put(:width, width+1)
    |> Map.put(:height, height+1)
  end

  def tree?("#"), do: true
  def tree?("."), do: false

  @doc """
      iex> "..##.......
      ...>#...#...#..
      ...>.#....#..#.
      ...>..#.#...#.#
      ...>.#...##..#.
      ...>..#.##.....
      ...>.#.#.#....#
      ...>.#........#
      ...>#.##...#...
      ...>#...##....#
      ...>.#..#...#.#"
      ...> |> setup_string
      ...> |> p1
      7
  """
  def p1(map, coords \\ {0, 0}, trees \\ 0)
  def p1(map, {x, y}, trees) do
    if y >= Map.get(map, :height) do
      trees
    else
      x_position = Integer.mod(x, Map.get(map, :width))
      if Map.get(map, {x_position, y}) do
        p1(map, {x+3, y+1}, trees+1)
      else
        p1(map, {x+3, y+1}, trees)
      end
    end
  end
  def p2(_i), do: nil
end
