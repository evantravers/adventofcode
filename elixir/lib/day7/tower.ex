require IEx

defmodule Advent2017.Day7 do
  def build_tree(file_name) do
    {:ok, file} = File.read("lib/day7/#{file_name}")

    edges =
      file
      |> String.split("\n", [trim: true])
      |> Enum.filter(&String.match? &1, ~r/->/)
      |> Enum.map(fn line ->
        [attr, children] = String.split(line, " -> ", [trim: true])
        [name, weight] = List.flatten(Regex.scan(~r/\w+/, attr))

        children
        |> String.split(", ")
        |> Enum.map(fn child ->
          {name, child, weight: String.to_integer(weight)}
        end)
      end)
      |> List.flatten

    Graph.new
    |> Graph.add_edges(edges)
  end

  def p1 do
    build_tree("input.txt")
    |> Graph.topsort
    |> List.first
  end
end
