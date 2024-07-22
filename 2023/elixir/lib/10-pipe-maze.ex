defmodule Advent2023.Day10 do
  @moduledoc "https://adventofcode.com/2023/day/10"

  def setup do
    with {:ok, file} <- File.read("../input/10") do
      file |> setup_from_string
    end
  end

  def setup_from_string(str) do
    graph =
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

    animal =
      graph
      |> Graph.vertices
      |> Enum.find(fn v -> Graph.vertex_labels(graph, v) == [:S] end)

    start =
      graph
      |> Graph.in_neighbors(animal)
      |> hd

    loop = crawl(graph, start)

    {graph, loop}
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

  def highlight(str), do: "#{IO.ANSI.yellow_background}#{str}#{IO.ANSI.default_background}"

  def print(graph, list \\ []) do
    IO.puts IO.ANSI.clear

    max =
      graph
      |> Graph.vertices
      |> Enum.map(&elem(&1, 0))
      |> Enum.max

    for y <- 0..max do
      for x <- 0..max do
        char = Graph.vertex_labels(graph, {x, y}) |> List.first || " "
        if Enum.member?(list, {x, y}), do: highlight(char), else: char
      end
      |> Enum.join
      |> Kernel.<>("\n")
    end
    |> Enum.join
    |> IO.puts

    graph
  end

  def crawl(graph, start), do: crawl(graph, [start], [])

  def crawl(_graph, [], visited), do: visited
  def crawl(graph, [vert|queue], visited) do
    todo = Graph.out_neighbors(graph, vert) -- visited

    crawl(graph, todo ++ queue, [vert|visited])
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
  def p1({_graph, loop}) do
    # print(graph, loop)

    loop
    |> Enum.count
    |> div(2)
  end

  def label(graph, coord), do: Graph.vertex_labels(graph, coord) |> hd

  def is_wall?(%{graph: graph, loop: loop}, coord) do
    Enum.member?(loop, coord) and label(graph, coord) == "┃"
  end

  def is_corner?(%{graph: graph, loop: loop} = world, coord) do
    Enum.member?(loop, coord)
    and label(graph, coord) != "━"
    and !is_wall?(world, coord)
  end

  def count_in_row(list_of_coords, state), do: outside(list_of_coords, state)

  def outside([], state), do: state
  def outside([coord|tail], state) do
    cond do
      is_wall?(coord, state) -> inside(tail, state)
      is_corner?(coord, state) -> corner(tail, label(coord), state)
      true -> outside(tail, state)
    end
  end

  def inside([], state), do: state
  def inside([coord|tail], state) do
    cond do
      is_wall?(coord, state) -> outside(tail, state)
      is_corner?(coord, state) -> corner(tail, label(coord), state)
      true -> inside(tail, Map.update(state, :score, 1, & &1 + 1))
    end
  end

  def corner([], state), do: state
  def corner(["-"]|tail), last_bend, state), do: corner(tail, last_bend, state)
  def corner([coord|tail], last_bend, state)

  @doc """
  How many tiles are enclosed by the loop?

  iex> "...........
  ...>.S-------7.
  ...>.|F-----7|.
  ...>.||.....||.
  ...>.||.....||.
  ...>.|L-7.F-J|.
  ...>.|..|.|..|.
  ...>.L--J.L--J.
  ...>..........."
  ...> |> setup_from_string
  ...> |> p2
  4

  iex> "...........
  ...>.S-------7.
  ...>.|...7...|.
  ...>.|.......|.
  ...>.|...J...|.
  ...>.|.FL-...|.
  ...>.|.......|.
  ...>.L-------J.
  ...>..........."
  ...> |> setup_from_string
  ...> |> p2
  35

  iex> ".F----7F7F7F7F-7....
  ...>.|F--7||||||||FJ....
  ...>.||.FJ||||||||L7....
  ...>FJL7L7LJLJ||LJ.L-7..
  ...>L--J.L7...LJS7F-7L7.
  ...>....F-J..F7FJ|L7L7L7
  ...>....L7.F7||L7|.L7L7|
  ...>.....|FJLJ|FJ|F7|.LJ
  ...>....FJL-7.||.||||...
  ...>....L---J.LJ.LJLJ..."
  ...> |> setup_from_string
  ...> |> p2
  8

  iex> "FF7FSF7F7F7F7F7F---7
  ...>L|LJ||||||||||||F--J
  ...>FL-7LJLJ||||||LJL-77
  ...>F--JF--7||LJLJ7F7FJ-
  ...>L---JF-JLJ.||-FJLJJ7
  ...>|F|F-JF---7F7-L7L|7|
  ...>|FFJF7L7F-JF7|JL---7
  ...>7-L-JL7||F7|L7F-7F7|
  ...>L.L7LFJ|||||FJL7||LJ
  ...>L7JLJL-JLJLJL--JLJ.L"
  ...> |> setup_from_string
  ...> |> p2
  10
  """
  def p2({graph, loop}) do
    max =
      graph
      |> Graph.vertices
      |> Enum.map(&elem(&1, 0))
      |> Enum.max

    # New insight: You only cross "in" when it's either a vertical wall "|" or
    # when you have two bends that both have a vertical dimension.
    # so there's actually a way to be 50% `inside?`.
    #
    # I'd need something like a functional state machine that given a certain
    # label or connected graph can determine whether the wall becomes open or
    # whether it curves back on itself.
    inside_characters =
      for y <- 0..max do
        for x <- 0..max do
          {x, y}
        end
        |> count_inside(graph, loop)
      end
      |> List.flatten

    print(graph, inside_characters)

    Enum.count(inside_characters)
  end
end
