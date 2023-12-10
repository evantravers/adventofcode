defmodule Advent2023.Day10 do
  @moduledoc "https://adventofcode.com/2023/day/10"

  def setup do
    with {:ok, file} <- File.read("../input/10") do
      file |> setup_with_string
    end
  end

  def setup_with_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.reduce(Graph.new(), fn ({row, y}, graph) ->
      row
      |> String.codepoints
      |> Enum.with_index
      |> Enum.reduce(graph, fn ({char, x}, graph) ->
        read_pipe(char, {x, y}, graph)
      end)
    end)
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
  def read_pipe("|", {x, y}, graph) do
    graph
    |> Graph.add_edge({x, y}, {x, y+1})
    |> Graph.add_edge({x, y}, {x, y-1})
  end
  def read_pipe("-", {x, y}, graph) do
    graph
    |> Graph.add_edge({x, y}, {x-1, y})
    |> Graph.add_edge({x, y}, {x+1, y})
  end
  def read_pipe("L", {x, y}, graph) do
    graph
    |> Graph.add_edge({x, y}, {x, y-1})
    |> Graph.add_edge({x, y}, {x+1, y})
  end
  def read_pipe("J", {x, y}, graph) do
    graph
    |> Graph.add_edge({x, y}, {x, y-1})
    |> Graph.add_edge({x, y}, {x-1, y})
  end
  def read_pipe("7", {x, y}, graph) do
    graph
    |> Graph.add_edge({x, y}, {x, y+1})
    |> Graph.add_edge({x, y}, {x-1, y})
  end
  def read_pipe("F", {x, y}, graph) do
    graph
    |> Graph.add_edge({x, y}, {x, y+1})
    |> Graph.add_edge({x, y}, {x+1, y})
  end
  def read_pipe(".", _coords, graph), do: graph
  def read_pipe("S", {x, y}, graph) do
    graph
    |> Graph.add_vertex("S", {x, y})
  end

  @doc """
  iex> "7-F7-
  ...>.FJ|7
  ...>SJLL7
  ...>|F--J
  ...>LJ.LJ"
  ...> |> setup_with_string
  ...> |> p1
  8

  How many steps along the loop does it take to get from the starting position
  to the point farthest from the starting position?
  """
  def p1(graph) do
    graph
    |> Graph.components
    |> IO.inspect
  end

  def p2(_i), do: nil
end
