defmodule Advent2018.Day7 do
  @moduledoc "https://adventofcode.com/2018/day/7"

  def load_input(file \\ "input.txt") do
    with {:ok, file} <- File.read("#{__DIR__}/#{file}") do
      file
      |> String.split("\n", trim: true)
      |> Enum.reduce(Graph.new(), &read_string_into_graph/2)
    end
  end

  @doc """
      iex> weight("A")
      61
      iex> weight("Z")
      86
  """
  def weight(label) do
    ?A..?Z
    |> Enum.find_index(&hd(String.to_charlist(label)) == &1)
    |> Kernel.+(61)
  end

  def read_string_into_graph(str, graph) do
    [[_, parent], [_, child]] =
      ~r/step ([A-Z])/i
      |> Regex.scan(str)

    Graph.add_edge(graph, parent, child, weight: weight(child))
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

  def p1 do
    load_input()
    |> search
  end

  def p2 do
    load_input()
  end
end
