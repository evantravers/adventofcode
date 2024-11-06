defmodule Advent2023.Day11 do
  @behaviour Advent
  @moduledoc "https://adventofcode.com/2023/day/11"

  def setup do
    with {:ok, file} <- File.read("../input/11") do
      file
      |> setup_with_string
    end
  end

  def setup_with_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.reduce([], fn {line, y}, world ->
      line
      |> String.codepoints
      |> Enum.with_index
      |> Enum.reduce(world, fn
        {"#", x}, world -> [{x, y}|world]
              _ , world -> world
      end)
    end)
  end

  @doc """
  iex> "...#......
  ...>.......#..
  ...>#.........
  ...>..........
  ...>......#...
  ...>.#........
  ...>.........#
  ...>..........
  ...>.......#..
  ...>#...#....."
  ...> |> setup_with_string
  ...> |> p1
  374
  """
  def p1(world) do
    world
    # Let's think about this.
    # I don't want to store every empty spot, because while it works in tests,
    # it's going to fail on the input.
  end

  def p2(_world), do: nil
end
