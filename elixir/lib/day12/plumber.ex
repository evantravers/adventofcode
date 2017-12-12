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

  @doc """
  Takes a set of nodes. On being run, it instantiates an empty list for todo
  and an empty set for visited nodes. It finds the node that matches todo and
  adds all it's unvisited pipe-nodes to todo, the current node to visited, and
  runs itself on the new lists.
  """
  def build_graph(nodes, todos \\ [0], visited \\ MapSet.new)
  def build_graph(_, [], visited), do: visited # win condition
  def build_graph(nodes, [todo|todos], visited) do
    unvisited =
      Enum.find(nodes, & todo == &1[:name])
      |> Map.fetch!(:pipes)
      |> MapSet.difference(visited) # list of unvisited
      |> MapSet.to_list

    build_graph(nodes, todos ++ unvisited, MapSet.put(visited, todo))
  end

  @doc """
  Run `build_graph/3` on the head node. It will return a MapSet group of
  connected nodes. Remove those nodes from nodes, repeat and count.
  """
  def find_groups(nodes, count \\ 0)
  def find_groups([], count), do: count
  def find_groups(nodes, count) do
    start = hd(nodes)[:name]
    group = build_graph(nodes, [start])

    nodes
    |> Enum.reject(fn (item) -> MapSet.member?(group, item[:name]) end)
    |> find_groups(count+1)
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

  def p2 do
    load_nodes("input.txt")
    |> find_groups
  end
end
