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
    |> String.pad_leading(128, "0")
  end

  @spec defrag(String) :: List
  def defrag(input) do
    Enum.map(0..127, fn row ->
      "#{input}-#{row}"
      |> Knot.dense_hash
      |> hex_to_bin
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  Transforms a "grid" of nested lists into a mapset of tuple coords.
  """
  def list_grid_to_map_grid(grid) do
    for {row, y} <- Enum.with_index(grid),
      {val, x} <- Enum.with_index(row),
      val == 1
    do
      {x, y}
    end
    |> Enum.into(MapSet.new())
  end

  @doc """
  iex> adjacent({2, 2})
  [{3, 2}, {1, 2}, {2, 3}, {2, 1}]
  """
  def adjacent({x, y}) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
  end

  @doc """
  `contiguous` taking a grid and a coordinate, finds all the coords in the grid
  that are attached to that original coord
  """
  def contiguous(grid, coord), do: contiguous(grid, [coord], MapSet.new)

  def contiguous(_, [], results), do: results
  def contiguous(grid, [square|todo], results) do
    if Enum.member?(grid, square) and !Enum.member?(results, square) do
      contiguous(grid, adjacent(square) ++ todo, MapSet.put(results, square))
    else
      contiguous(grid, todo, results)
    end
  end

  @doc """
  This assumes that todo is a MapSet of coord tuples.

  Algorithm:

  find a 1 block that isn't a member of any group in groups
    run `contiguous/2` on it to get a MapSet of the group.
    store the group in groups
    repeat

  return groups
  """
  @spec find_groups(MapSet, MapSet, List) :: List
  def find_groups(todo, visited \\ MapSet.new, groups \\ []) do
    if Enum.empty?(todo) do
      groups
    else
      [start_node] = Enum.take(todo, 1)
      group        = contiguous(todo, start_node)
      visited      = MapSet.union(visited, group)
      todo         = MapSet.difference(todo, visited)

      find_groups(todo, visited, [group | groups])
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
