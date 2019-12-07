defmodule Advent2019.Day6 do
  @moduledoc "https://adventofcode.com/2019/day/6"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      string_to_graph(file)
    end
  end

  def string_to_graph(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.reduce(Graph.new, &eval_orbit/2)
  end

  def eval_orbit(string, graph) do
    [a, b] = String.split(string, ")", trim: true)

    Graph.add_edge(graph, a, b)
  end

  @doc """
  What is the total number of direct and indirect orbits in your map data?

      iex> "COM)B
      ...>B)C
      ...>C)D
      ...>D)E
      ...>E)F
      ...>B)G
      ...>G)H
      ...>D)I
      ...>E)J
      ...>J)K
      ...>K)L"
      ...> |> string_to_graph
      ...> |> p1
      42
  """
  def p1(graph) do
    graph
    |> Graph.vertices
    |> Enum.map(fn(v) ->
      if v == "COM" do
        0
      else
        graph
        |> Graph.get_shortest_path("COM", v)
        |> Enum.count
        |> Kernel.-(1) # don't count yourself
      end
    end)
    |> Enum.sum
  end

  @doc """
  What is the total number of direct and indirect orbits in your map data?

      iex> "COM)B
      ...>B)C
      ...>C)D
      ...>D)E
      ...>E)F
      ...>B)G
      ...>G)H
      ...>D)I
      ...>E)J
      ...>J)K
      ...>K)L
      ...>K)YOU
      ...>I)SAN"
      ...> |> string_to_graph
      ...> |> p2
      4
  """
  def p2(graph) do
    santas_orbital_path =
      graph
      |> Graph.get_shortest_path("COM", "SAN")
      |> Enum.reverse

    your_orbital_path =
      graph
      |> Graph.get_shortest_path("COM", "YOU")
      |> Enum.reverse

    shared_root =
      Enum.find(santas_orbital_path, fn(node) ->
        Enum.any?(your_orbital_path, & node == &1)
      end)

    santa_jumps =
      graph
      |> Graph.get_shortest_path(shared_root, "SAN")
      |> Enum.count
      |> Kernel.-(2)

    you_jumps =
      graph
      |> Graph.get_shortest_path(shared_root, "YOU")
      |> Enum.count
      |> Kernel.-(2)

    santa_jumps + you_jumps
  end
end
