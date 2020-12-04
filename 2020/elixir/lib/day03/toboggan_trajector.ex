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

  def slide(map, slope \\ {3, 1}, coords \\ {0, 0}, trees \\ 0)
  def slide(map, {x_slope, y_slope} = slope, {x, y}, trees) do
    if y >= Map.get(map, :height) do
      trees
    else
      x_position = Integer.mod(x, Map.get(map, :width))
      if Map.get(map, {x_position, y}) do
        slide(map, slope, {x+x_slope, y+y_slope}, trees+1)
      else
        slide(map, slope, {x+x_slope, y+y_slope}, trees)
      end
    end
  end

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
  def p1(input), do: slide(input)

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
      ...> |> p2
      336
  """
  def p2(input) do
    # Right 1, down 1.
    slide(input, {1, 1}) *
    # Right 3, down 1. (This is the slope you already checked.)
    slide(input, {3, 1}) *
    # Right 5, down 1.
    slide(input, {5, 1}) *
    # Right 7, down 1.
    slide(input, {7, 1}) *
    # Right 1, down 2.
    slide(input, {1, 2})
  end
end
