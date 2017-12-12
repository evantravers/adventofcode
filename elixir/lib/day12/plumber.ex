require IEx
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
      |> (fn(n) -> %{name: hd(n), pipes: MapSet.new(tl(n))} end).()
    end)
  end

  def build_graph(nodes, target, visited \\ MapSet.new)
  def build_graph(nodes, target, visited) do
    Enum.find(nodes, fn(n) -> n[:name] == target end)
    |> Map.fetch!(:pipes)
    |> MapSet.difference(visited) # remove visited
    |> Enum.map(fn (link) ->
      build_graph(nodes, link, MapSet.put(visited, link))
    end)
  end

  def test do
    load_nodes("test.txt")
    |> build_graph(0)
  end

  def p1 do
    load_nodes("input.txt")
    |> build_graph(0)
  end
end
