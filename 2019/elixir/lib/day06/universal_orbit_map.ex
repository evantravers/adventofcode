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
      end
    end)
    |> Enum.sum
  end

  def p2(graph) do
    nil
  end
end
