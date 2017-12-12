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

  def build_graph(nodes, todos \\ [0], visited \\ MapSet.new)
  def build_graph(nodes, [], visited), do: visited # win condition
  def build_graph(nodes, [todo|todos], visited) do
    unvisited =
      Enum.find(nodes, & todo == &1[:name])
      |> Map.fetch!(:pipes)
      |> MapSet.difference(visited) # list of unvisited
      |> MapSet.to_list

    build_graph(nodes, todos ++ unvisited, MapSet.put(visited, todo))
  end

  def test do
    load_nodes("test.txt")
    |> build_graph
    |> MapSet.size
  end

  def p1 do
    load_nodes("input.txt")
    |> build_graph
    |> MapSet.size
  end
end
