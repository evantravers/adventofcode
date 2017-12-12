defmodule Advent2017.Day12 do
  @doc ~S"""
  Returns a list of lists, where the index in the first list is the id of the
  node, and the nested list is the links
  """
  def load_nodes(file) do
    {:ok, file} = File.read("lib/day12/#{file}")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(fn pattern ->
      Regex.scan(~r/\d+/, pattern)
      |> List.flatten
      |> Enum.map(&String.to_integer &1)
      |> tl
    end)
  end

  def build_graph(list_of_nodes, visited \\ []) do

  end

  def p1 do
    load_nodes("input.txt")
    |> build_graph
  end
end
