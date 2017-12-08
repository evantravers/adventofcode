defmodule Advent2017.Day6 do
  @doc ~S"""
  Finds the most populated bank in `list`, and redistributes it across the
  other banks.

      iex> Advent2017.Day6.cycle([0, 2, 7, 0])
      [2, 4, 1, 2]
      iex> Advent2017.Day6.cycle([2, 4, 1, 2])
      [3, 1, 2, 3]
      iex> Advent2017.Day6.cycle([3, 1, 2, 3])
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
    rotated_list = rotate_to(list, index_of_max+1)

    redistribute(rotated_list, max)
    |> sort_banks
  end

  def redistribute(list, 0), do: list

  def redistribute([h|t], spare_blocks) do
    {head, index} = h
    redistribute(t ++ [{head+1, index}], spare_blocks-1)
  end

  @doc ~S"""
      iex> Advent2017.Day6.rotate_to([1,2,3], 1)
      [2, 3, 1]
      iex> Advent2017.Day6.rotate_to([1,2,3], 0)
      [1, 2, 3]
  """
  def rotate_to(list, 0), do: list

  def rotate_to(list, index) do
    Enum.slice(list, index..-1) ++ Enum.slice(list, 0..index-1)
  end

  def sort_banks(list) do
    list
    |> Enum.sort(fn({_, i1}, {_, i2}) -> i1 <= i2 end)
    |> Enum.unzip
    |> elem(0)
  end

  @doc ~S"""
      iex> Advent2017.Day6.largest_bank([{1,1}, {2,0}])
      {2,0}
      iex> Advent2017.Day6.largest_bank([{2,0}, {1,1}])
      {2,0}
      iex> Advent2017.Day6.largest_bank([{2,0}, {2, 1}, {1,2}])
      {2,0}
      iex> Advent2017.Day6.largest_bank([{1, 5}, {5, 0}, {2, 3}, {5, 1}])
      {5, 0}
  """
  def largest_bank(list) do
    # because the list is of tuples where I'm tracking their original location
    # I have to have a custom sort. I probably would have done better to have
    # some other structure. :(
    list
    |> Enum.sort(fn({v1, i1}, {v2, i2}) -> i1 <= i2 && v1 >= v2 end)
    |> List.first
  end

  @doc ~S"""
      iex> Advent2017.Day6.balance([0, 2, 7, 0])
      5
  """
  def balance(configuration, visited \\ MapSet.new) do
    cond do
      MapSet.member?(visited, configuration) ->
        Enum.count(visited)
      true ->
        configuration
        |> cycle
        |> balance(MapSet.put(visited, configuration))
    end
  end

  def load_file do
    {:ok, file} = File.read("lib/day6/test.txt")

    file
    |> String.split("\t", [trim: true])
    |> Enum.map(&(String.to_integer(String.trim(&1))))
  end

  def p1 do
    load_file()
    |> balance
  end

  def p2, do: "nil"
end
