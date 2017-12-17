require IEx

defmodule Advent2017.Day7 do
  def read_input(file_name) do
    {:ok, file} = File.read("lib/day7/#{file_name}")

    edges =
      file
      |> String.split("\n", [trim: true])
      |> Enum.filter(&String.match? &1, ~r/->/)
      |> Enum.map(fn line ->
        [attr, children] = String.split(line, " -> ", [trim: true])
        [name] = Regex.run(~r/\w+/, attr)

        children
        |> String.split(", ")
        |> Enum.map(fn child -> {name, child} end)
      end)
      |> List.flatten

    Graph.new
    |> Graph.add_edges(edges)
  end

  def p1 do
    read_input("input.txt")
    |> Graph.top_sort
    |> List.first
  end
end
