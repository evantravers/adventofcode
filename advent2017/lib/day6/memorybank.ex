defmodule Advent2017.Day6 do
  @doc ~S"""
  Finds the most populated bank in `list`, and redistributes it across the
  other banks.

      iex> Advent2017.Day6.reallocate([0, 2, 7, 0])
      [2, 4, 1, 2]
      iex> Advent2017.Day6.reallocate([2, 4, 1, 2])
      [3, 1, 2, 3]
      iex> Advent2017.Day6.reallocate([3, 1, 2, 3])
      [0, 2, 3, 4]
  """
  @spec reallocate(list) :: list
  def reallocate(list) do
    list =
      list
      |> Enum.with_index

    {max, index_of_max} =
      list
      |> largest_bank

    list = List.replace_at(list, index_of_max, {0, index_of_max})

    # rotate the list to the bank after the "max" bank
    rotated_list = rotate_to(list, index_of_max+1)

    distribute_blocks(rotated_list, max)
    |> sort_banks
  end

  def distribute_blocks(list, 0), do: list

  def distribute_blocks([h|t], spare_blocks) do
    {head, index} = h
    distribute_blocks(t ++ [{head+1, index}], spare_blocks-1)
  end

  @doc ~S"""
      iex> Advent2017.Day6.rotate_to([1,2,3], 1)
      [2, 3, 1]
      iex> Advent2017.Day6.rotate_to([1,2,3], 0)
      [1, 2, 3]
  """
  def rotate_to(list, 0) do
    list
  end

  def rotate_to(list, index) do
    Enum.slice(list, index..-1) ++ Enum.slice(list, 0..index-1)
  end

  def sort_banks(list) do
    list
    |> Enum.sort(fn({_, i1}, {_, i2}) -> i1 <= i2 end)
    |> Enum.unzip
    |> elem(0)
  end

  def largest_bank(list) do
    list
    |> Enum.sort(fn({v1, i1}, {v2, i2}) -> i1 <= i2 && v1 >= v2 end)
    |> List.first
  end

  def run do
    {:ok, file} = File.read("lib/day6/input.txt")

    banks =
      file
      |> String.split("\t", [trim: true])
      |> Enum.map(&(String.to_integer(String.trim(&1))))

    reallocate(banks)
  end
end
