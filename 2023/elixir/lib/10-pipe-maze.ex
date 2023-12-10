defmodule Advent2023.Day10 do
  @moduledoc "https://adventofcode.com/2023/day/10"

  require LibGraph

  def setup do
    with {:ok, file} <- File.read("../input/10") do
      file
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn ({row, y}, map) ->
        row
        |> String.codepoints
        |> Enum.with_index
        |> Enum.reduce(map, fn ({char, x}, map) ->
          Map.put(map, {x, y}, char)
        end)
      end)
    end
  end

  @doc """
  | is a vertical pipe connecting north and south.
  - is a horizontal pipe connecting east and west.
  L is a 90-degree bend connecting north and east.
  J is a 90-degree bend connecting north and west.
  7 is a 90-degree bend connecting south and west.
  F is a 90-degree bend connecting south and east.
  . is ground; there is no pipe in this tile.
  S is the starting position of the animal; there is a pipe on this tile, but your sketch doesn't show what shape the pipe has.
  """
  def pipe

  def p1(map) do
    # find S
  end

  def p2(_i), do: nil
end
