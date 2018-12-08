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
    graph
    |> Graph.in_neighbors(node)
    |> Enum.all?(&MapSet.member?(visited, &1))
  end

  def search(graph, queue, visited \\ MapSet.new, result \\ "")
  def search(_, [], _, result), do: result
  def search(graph, [node|queue], visited, result) do
    if reqs_satisfied(graph, node, visited) do
      neighbors =
        graph
        |> Graph.out_neighbors(node)
        |> Enum.sort
        |> Enum.reject(&MapSet.member?(visited, &1))
        |> Enum.reject(&Enum.member?(queue, &1))

      search(graph, neighbors ++ queue, MapSet.put(visited, node), result <> node)
    else
      search(graph, enqueue(queue, node), visited, result)
    end
  end

  def enqueue(queue, node) do
    [node| Enum.reverse(queue)]
    |> Enum.reverse
  end

  def alphabetical_path(graph) do
    start = graph
            |> Graph.vertices
            |> Enum.filter(fn(v) ->
              graph
              |> Graph.in_neighbors(v)
              |> Enum.empty?
            end)
            |> Enum.sort

    search(graph, start)
  end

  def p1 do
    load_input()
    |> alphabetical_path
  end
  def p2, do: nil
end
