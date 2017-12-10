defmodule Advent2017.Day10 do
  @doc ~S"""
  For each length:
  - Reverse the order of that length of elements in the list, starting with the
    element at the current position.
  - Move the current position forward by that length plus the skip size.
  - Increase the skip size by one.

      iex> Enum.to_list(0..4)
      ...> |> Advent2017.Day10.knot([3, 4, 1, 5])
      ...> |> elem(1)
      [3, 4, 2, 1, 0]
  """
  def knot(list, current_position \\ 0, skip_size \\ 0, lengths) # defaults
  def knot(list, current_position, skip_size, []) do
    {{current_position, skip_size}, list}
  end
  def knot(list, current_position, skip_size, [l|next_length]) do
    list
    |> rotate(rem(current_position, length(list)))
    |> Enum.reverse_slice(0, l)
    |> unrotate(rem(current_position, length(list)))
    |> knot(current_position+l+skip_size, skip_size+1, next_length)
  end

  def rotate(list, 0), do: list
  def rotate(list, index) do
    Enum.slice(list, index..-1) ++ Enum.slice(list, 0..index-1)
  end

  def unrotate(list, index), do: rotate(list, index * -1)

  def p1 do
    {:ok, file} = File.read("./lib/day10/input.txt")

    lengths =
      file
      |> String.trim
      |> String.split(",", [trim: true])
      |> Enum.map(&(String.to_integer(&1)))

    {_, resulting_list} = knot(Enum.to_list(0..255), lengths)
    Enum.at(resulting_list, 0) * Enum.at(resulting_list, 1)
  end

  def p2 do
    # {:ok, file} = File.read("./lib/day10/input.txt")
  end
end
