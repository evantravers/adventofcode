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
        [parent, weight] = List.flatten(Regex.scan(~r/\w+/, attr))

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

  def p1 do
    build_tree("test.txt")
    |> Graph.topsort
    |> List.first
  end

  def p2 do
    g    = build_tree("test.txt")
    root = p1

    # for each leaf node, calculate the weight between root and leaf and print
  end

  def circus_weight(g, node) do
    Graph.edges(Graph.subgraph(g, Graph.reachable(g, [node])))
    |> Enum.reduce(0, fn edge, sum -> sum + edge.weight end)
  end
end
