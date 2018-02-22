defmodule Advent2017.Day6 do
  @moduledoc """
  A debugger program here is having an issue: it is trying to repair a memory
  reallocation routine, but it keeps getting stuck in an infinite loop.

  In this area, there are sixteen memory banks; each memory bank can hold any
  number of blocks. The goal of the reallocation routine is to balance the
  blocks between the memory banks.

  The reallocation routine operates in cycles. In each cycle, it finds the
  memory bank with the most blocks (ties won by the lowest-numbered memory
  bank) and redistributes those blocks among the banks. To do this, it removes
  all of the blocks from the selected bank, then moves to the next (by index)
  memory bank and inserts one of the blocks. It continues doing this until it
  runs out of blocks; if it reaches the last memory bank, it wraps around to
  the first one.

  The debugger would like to know how many redistributions can be done before a
  blocks-in-banks configuration is produced that has been seen before.
  """

  @doc ~S"""
  Finds the most populated bank in `list`, and redistributes it across the
  other banks.

      iex> cycle([0, 2, 7, 0])
      [2, 4, 1, 2]
      iex> cycle([2, 4, 1, 2])
      [3, 1, 2, 3]
      iex> cycle([3, 1, 2, 3])
      [0, 2, 3, 4]
  """
  @spec cycle(list) :: list
  def cycle(list) do
    list =
      list
      |> Enum.with_index

    {max, index_of_max} =
      list
      |> largest_bank

    list = List.replace_at(list, index_of_max, {0, index_of_max})

    # rotate the list to the bank after the "max" bank
    rotated_list = rotate_to(list, index_of_max + 1)

    rotated_list
    |> redistribute(max)
    |> sort_banks
  end

  @doc ~S"""
      iex> redistribute([{1, 0}, {2, 1}, {3, 2}, {0, 3}], 3)
      ...> |> Advent2017.Day6.sort_banks
      [2, 3, 4, 0]
  """
  def redistribute(list, 0), do: list

  def redistribute([h|t], spare_blocks) do
    {head, index} = h
    redistribute(t ++ [{head + 1, index}], spare_blocks - 1)
  end

  @doc ~S"""
      iex> rotate_to([1,2,3], 1)
      [2, 3, 1]
      iex> rotate_to([1,2,3], 0)
      [1, 2, 3]
  """
  def rotate_to(list, 0), do: list

  def rotate_to(list, index) do
    Enum.slice(list, index..-1) ++ Enum.slice(list, 0..index - 1)
  end

  @doc ~S"""
  Sorts a list of tuples (from `Enum.with_index`) back into it's original state

      iex> sort_banks([{1, 0}, {2, 1}, {3, 2}])
      [1, 2, 3]
      iex> sort_banks([{1, 1}, {2, 2}, {3, 0}])
      [3, 1, 2]
  """
  def sort_banks(list) do
    list
    |> Enum.sort(fn({_, i1}, {_, i2}) -> i1 <= i2 end)
    |> Enum.unzip
    |> elem(0)
  end

  @doc ~S"""
      iex> largest_bank([{1,1}, {2,0}])
      {2,0}
      iex> largest_bank([{2,0}, {1,1}])
      {2,0}
      iex> largest_bank([{2,0}, {2, 1}, {1,2}])
      {2,0}
      iex> largest_bank([{1, 5}, {5, 0}, {2, 3}, {5, 1}])
      {5,0}
      iex> largest_bank([{1, 5}, {0, 4}, {5, 0}, {6, 2}, {2, 3}, {5, 1}])
      {6, 2}
  """
  def largest_bank(list) do
    # because the list is of tuples where I'm tracking their original location
    # I have to have a custom sort. I probably would have done better to have
    # some other structure. :(
    list
    |> Enum.sort(fn({v1, _}, {v2, _}) -> v1 >= v2 end)
    |> List.first
  end

  @doc ~S"""
      iex> balance([0, 2, 7, 0])
      %{cycles: 5, distance: 4}
  """
  def balance(configuration, visited \\ []) do
    if Enum.any?(visited, &(configuration == &1)) do
      %{cycles: Enum.count(visited),
        distance: Enum.count(visited) - Enum.find_index(visited, &(configuration == &1))}
    else
      configuration
      |> cycle
      |> balance(visited ++ [configuration])
    end
  end

  def load_file do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    file
    |> String.split("\t", [trim: true])
    |> Enum.map(&(String.to_integer(String.trim(&1))))
  end

  def p1 do
    load_file()
    |> balance
    |> Map.fetch!(:cycles)
  end

  def p2 do
    load_file()
    |> balance
    |> Map.fetch!(:distance)
  end
end
