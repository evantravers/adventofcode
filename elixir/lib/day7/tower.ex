require IEx

defmodule Advent2017.Day7 do
  def build_tree(file_name) do
    {:ok, file} = File.read("lib/day7/#{file_name}")

    weights =
      file
      |> String.split("\n", [trim: true])
      |> Enum.reduce(%{}, fn line, map ->
        attr = hd(String.split(line, " -> ", [trim: true]))
        [name, weight] = List.flatten(Regex.scan(~r/\w+/, attr))
        Map.put(map, name, String.to_integer(weight))
      end)

    edges =
      file
      |> String.split("\n", [trim: true])
      |> Enum.filter(&String.match? &1, ~r/->/)
      |> Enum.map(fn line ->
        [attr, children] = String.split(line, " -> ", [trim: true])
        [parent, _] = List.flatten(Regex.scan(~r/\w+/, attr))

        children
        |> String.split(", ")
        |> Enum.map(fn child ->
          {parent, child, weight: weights[child]}
        end)
      end)
      |> List.flatten

    Graph.new
    |> Graph.add_edges(edges)
  end

  def all_the_same(list) do
    length(Enum.uniq(Enum.map(list, fn {weight, _} -> weight end))) == 1
  end

  def find_weakest_link(graph, n) do
    weights =
      graph
      |> Graph.out_neighbors(n)
      |> Enum.map(fn child -> {circus_weight(graph, child), child} end)
      |> List.keysort(0)
      |> Enum.reverse

    # if all my children have equal weights, I'm the fatty
    cond do
       all_the_same(weights) ->
         n
      true ->
        find_weakest_link(graph, elem(hd(weights), 1))
    end
  end

  def correct_weight(g, n) do
    [edge|_] = Graph.in_edges(g, n)

    [low, high] =
      Graph.out_neighbors(g, edge.v1)
      |> Enum.map(fn neighbor -> circus_weight(g, neighbor) end)
      |> Enum.uniq
      |> Enum.sort

    edge.weight - (high - low)
  end

  def circus_weight(g, node) do
    children =
      Graph.edges(Graph.subgraph(g, Graph.reachable(g, [node])))
      |> Enum.reduce(0, fn edge, sum -> sum + edge.weight end)

    ownweight =
      Graph.in_edges(g, node)
      |> Enum.reduce(0, fn edge, sum -> sum + edge.weight end)

    ownweight + children
  end

  def p1 do
    build_tree("input.txt")
    |> Graph.topsort
    |> List.first
  end

  def p2 do
    g    = build_tree("input.txt")
    root = p1()

    correct_weight(g, find_weakest_link(g, root))
  end
end
