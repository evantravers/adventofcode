defmodule Advent2023.Day10 do
  @moduledoc "https://adventofcode.com/2023/day/10"

  def setup do
    with {:ok, file} <- File.read("../input/10") do
      file |> setup_from_string
    end
  end

  def setup_from_string(str) do
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
    |> Graph.label_vertex({x, y}, "┃")
  end
  def read_pipe("-", {x, y}, graph) do
    graph
    |> Graph.add_edge({x, y}, {x-1, y})
    |> Graph.add_edge({x, y}, {x+1, y})
    |> Graph.label_vertex({x, y}, "━")
  end
  def read_pipe("L", {x, y}, graph) do
    graph
    |> Graph.add_edge({x, y}, {x, y-1})
    |> Graph.add_edge({x, y}, {x+1, y})
    |> Graph.label_vertex({x, y}, "┗")
  end
  def read_pipe("J", {x, y}, graph) do
    graph
    |> Graph.add_edge({x, y}, {x, y-1})
    |> Graph.add_edge({x, y}, {x-1, y})
    |> Graph.label_vertex({x, y}, "┛")
  end
  def read_pipe("7", {x, y}, graph) do
    graph
    |> Graph.add_edge({x, y}, {x, y+1})
    |> Graph.add_edge({x, y}, {x-1, y})
    |> Graph.label_vertex({x, y}, "┓")
  end
  def read_pipe("F", {x, y}, graph) do
    graph
    |> Graph.add_edge({x, y}, {x, y+1})
    |> Graph.add_edge({x, y}, {x+1, y})
    |> Graph.label_vertex({x, y}, "┏")
  end
  def read_pipe(".", _coords, graph), do: graph
  def read_pipe("S", {x, y}, graph) do
    if Graph.has_vertex?(graph, {x, y}) do
      Graph.label_vertex(graph, {x, y}, :S)
    else
      Graph.add_vertex(graph, {x, y}, :S)
    end
  end

  def green(str), do: "#{IO.ANSI.green}#{str}#{IO.ANSI.default_color}"

  def print(graph, loop \\ []) do
    IO.puts IO.ANSI.clear

    max =
      graph
      |> Graph.vertices
      |> Enum.map(&elem(&1, 0))
      |> Enum.max

    for y <- 0..max do
      for x <- 0..max do
        char = Graph.vertex_labels(graph, {x, y}) |> List.first
        if is_nil(char) do
          " "
        else
          if char == :S do
            "#{IO.ANSI.yellow_background}S#{IO.ANSI.default_background}"
          else
            if Enum.member?(loop, {x, y}), do: green(char), else: char
          end
        end
      end
      |> Enum.join
      |> Kernel.<>("\n")
    end
    |> Enum.join
    |> IO.puts

    graph
  end

  @doc """
  How many steps along the loop does it take to get from the starting position
  to the point farthest from the starting position?

  iex> ".....
  ...>.S-7.
  ...>.|.|.
  ...>.L-J.
  ...>....."
  ...> |> setup_from_string
  ...> |> p1
  4

  iex> "..F7.
  ...>.FJ|.
  ...>SJ.L7
  ...>|F--J
  ...>LJ..."
  ...> |> setup_from_string
  ...> |> p1
  8
  """
  def p1(graph) do
    animal =
      graph
      |> Graph.vertices
      |> Enum.find(fn v -> Graph.vertex_labels(graph, v) == [:S] end)

    loop =
      graph
      |> Graph.components()
      |> hd

    print(graph, loop)

    loop
    |> Enum.count
    |> div(2)
  end

  def p2(_i), do: nil
end
