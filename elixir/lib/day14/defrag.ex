require IEx

defmodule Advent2017.Day14 do
  alias Advent2017.Day10, as: Knot

  @spec hex_to_bin(String) :: String
  def hex_to_bin(str) do
    str
    |> String.to_integer(16)
    |> Integer.to_string(2)
  end

  @spec defrag(String) :: List
  def defrag(input) do
    Enum.map(0..127, fn row ->
      Knot.dense_hash("#{input}-#{row}")
      |> hex_to_bin
      |> String.split("", [trim: true])
      |> Enum.map(&String.to_integer &1)
    end)
  end

  @doc """
  Transforms a "grid" of nested lists into a "grid" of nested maps.

  You can then use `get_in/2` and 'update_in/3` to access the grid in the form:
  `get_in(grid, [x, y])`

  The reasoning for this is it will hopefully make bound detection easier.
  """
  def list_grid_to_map_grid(grid) do
    Enum.into(Enum.with_index(grid), %{}, fn ({v, k}) ->
      {k, Enum.into(Enum.with_index(v), %{}, fn({a, b}) ->
        {b, a}
      end)}
    end)
  end

  @doc """
      iex> Advent2017.Day14.adjacent([2, 2])
      [[3, 2], [1, 2], [2, 3], [2, 1]]
  """
  def adjacent([x, y]) do
    [[x+1, y], [x-1, y], [x, y+1], [x, y-1]]
  end

  @spec contiguous(Map, List, MapSet) :: MapSet
  def contiguous(grid, coords, group \\ MapSet.new) do
    case get_in(grid, coords) do
      nil -> group
        0 -> group
        1 ->
          neighbors = Enum.reject(adjacent(coords), &MapSet.member?(group, &1))
          unless Enum.empty? neighbors do
            Enum.map(neighbors, fn adj ->
              contiguous(grid, adj, MapSet.put(group, coords))
            end)
            |> Enum.reduce(&MapSet.union &1, &2)
          else
            group
          end
    end
  end

  @doc """
  Returns a coordinate in grid that has a 1 value, but isn't in visited.
  """
  @spec find_ungrouped(List, MapSet) :: List
  def find_ungrouped(grid, visited) do
    results =
      for x <- Map.keys(grid), y <- Map.keys(grid[x]), do: [[x, y], get_in(grid, [x, y])]

    results
    |> Enum.filter(fn [_, value] -> value == 1 end)
    |> Enum.reject(fn [[x, y], _] -> MapSet.member?(visited, [x, y]) end)
  end

  @doc """
  Expects the map of maps
  Algorithm:

  find a 1 block that isn't a member of any group in groups
    run `contiguous/2` on it to get a MapSet of the group.
    store the group in groups
    repeat

  return groups
  """
  def find_groups(grid, visited \\ MapSet.new, groups \\ []) do
    unvisited_nodes = find_ungrouped(grid, visited)

    unless length(unvisited_nodes) == 0 do
      start_node = hd(hd(unvisited_nodes))
      group = contiguous(grid, start_node)
      find_groups(grid, MapSet.union(visited, group), [group | groups] )
    else
      groups
    end
  end

  def p1 do
    defrag("ljoxqyyw")
    |> List.flatten
    |> Enum.sum
  end
  def p2 do
    defrag("ljoxqyyw")
    |> find_groups
  end
end
