defmodule Advent2018.Day7 do
  @moduledoc "https://adventofcode.com/2018/day/7"

  def load_input(file \\ "input.txt") do
    with {:ok, file} <- File.read("#{__DIR__}/#{file}") do
      file
      |> String.split("\n", trim: true)
      |> Enum.reduce(Graph.new(), &read_string_into_graph/2)
    end
  end

  def read_string_into_graph(str, graph) do
    [[_, parent], [_, child]] =
      ~r/step ([A-Z])/i
      |> Regex.scan(str)

    Graph.add_edge(graph, parent, child)
  end

  def reqs_satisfied(graph, node, visited) do
    not Enum.member?(visited, node)

    and

    (
      graph
      |> Graph.in_neighbors(node)
      |> Enum.empty?

      or

      graph
      |> Graph.in_neighbors(node)
      |> Enum.all?(&Enum.member?(visited, &1))
    )
  end

  def search(graph, visited \\ []) do
    to_visit =
      graph
      |> Graph.vertices
      |> Enum.filter(&reqs_satisfied(graph, &1, visited))
      |> Enum.sort

    if Enum.empty?(to_visit) do
      visited
      |> Enum.reverse
      |> Enum.join
    else
      search(graph, [hd(to_visit)|visited])
    end
  end

  def alphabetical_path(graph) do
    search(graph)
  end

  def p1 do
    load_input()
    |> alphabetical_path
  end
  def p2, do: nil
end
