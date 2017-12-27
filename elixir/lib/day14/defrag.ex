defmodule Advent2017.Day14 do
  @moduledoc """
  Suddenly, a scheduled job activates the system's disk defragmenter. Were the
  situation different, you might sit and watch it for a while, but today, you
  just don't have that kind of time. It's soaking up valuable system resources
  that are needed elsewhere, and so the only option is to help it finish its
  task as soon as possible.

  The disk in question consists of a 128x128 grid; each square of the grid is
  either free or used. On this disk, the state of the grid is tracked by the
  bits in a sequence of knot hashes.

  A total of 128 knot hashes are calculated, each corresponding to a single row
  in the grid; each hash contains 128 bits which correspond to individual grid
  squares. Each bit of a hash indicates whether that square is free (0) or used
  (1).

  The hash inputs are a key string (your puzzle input), a dash, and a number
  from 0 to 127 corresponding to the row. For example, if your key string were
  flqrgnkx, then the first row would be given by the bits of the knot hash of
  flqrgnkx-0, the second row from the bits of the knot hash of flqrgnkx-1, and
  so on until the last row, flqrgnkx-127.

  The output of a knot hash is traditionally represented by 32 hexadecimal
  digits; each of these digits correspond to 4 bits, for a total of 4 * 32 =
  128 bits. To convert to bits, turn each hexadecimal digit to its equivalent
  binary value, high-bit first: 0 becomes 0000, 1 becomes 0001, e becomes 1110,
  f becomes 1111, and so on; a hash that begins with a0c2017... in hexadecimal
  would begin with 10100000110000100000000101110000...  in binary.
  """

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
      "#{input}-#{row}"
      |> Knot.dense_hash
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
    [[x + 1, y], [x - 1, y], [x, y + 1], [x, y - 1]]
  end

  @spec contiguous(Map, List, MapSet) :: MapSet
  def contiguous(grid, coords, group \\ MapSet.new) do
    case get_in(grid, coords) do
      nil -> group
        0 -> group
        1 ->
          neighbors = Enum.reject(adjacent(coords), &MapSet.member?(group, &1))
          if Enum.empty? neighbors do
            group
          else
            neighbors
            |> Enum.map(fn adj ->
              contiguous(grid, adj, MapSet.put(group, coords))
            end)
            |> Enum.reduce(&MapSet.union &1, &2)
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

    if Enum.empty?(unvisited_nodes) do
      start_node = hd(hd(unvisited_nodes))
      group = contiguous(grid, start_node)
      find_groups(grid, MapSet.union(visited, group), [group | groups])
    else
      groups
    end
  end

  def p1 do
    "ljoxqyyw"
    |> defrag
    |> List.flatten
    |> Enum.sum
  end
  def p2 do
    "ljoxqyyw"
    |> defrag
    |> list_grid_to_map_grid
    |> find_groups
    |> Enum.count
  end
end
