require IEx

defmodule Advent2017.Day10 do
  use Bitwise

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

  def hash(list, _, _, _, 0), do: list
  def hash(list, position, skip, lengths, amount) do
    {{position, skip}, list} = knot(list, position, skip, lengths) # reuse opts
    hash(list, position, skip, lengths, amount-1)
  end

  @doc ~S"""
      iex> Advent2017.Day10.prep_lengths("1,2,3")
      [49,44,50,44,51,17,31,73,47,23]
  """
  def prep_lengths(input) do
    input
    |> String.trim
    |> String.to_charlist
    |> Enum.concat([17, 31, 73, 47, 23]) # magic chars
  end

  @doc ~S"""
      iex> Advent2017.Day10.dense_hash("")
      "a2582a3a0e66e6e86e3812dcb672a272"
      iex> Advent2017.Day10.dense_hash("AoC 2017")
      "33efeb34ea91902bb2f59c9920caa6cd"
      iex> Advent2017.Day10.dense_hash("1,2,3")
      "3efbe78a8d82f29979031a4aa0b16a9d"
      iex> Advent2017.Day10.dense_hash("1,2,4")
      "63960835bcdc130f0b66d7ff4f6a5a8e"
  """
  def dense_hash(input) do
    lengths = prep_lengths(input)

    Enum.to_list(0..255)
    |> hash(0, 0, lengths, 64)
    |> Enum.chunk_every(16)
    |> Enum.map(fn(chunk) -> 
      chunk
      |> Enum.reduce(&(&1 ^^^ &2))
      |> Integer.to_string(16)
      |> String.pad_leading(2, "0") # hex representation w/ leading 0
    end)
    |> Enum.join
    |> String.downcase
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    lengths =
      file
      |> String.trim
      |> String.split(",", [trim: true])
      |> Enum.map(&(String.to_integer(&1)))

    {_, resulting_list} = knot(Enum.to_list(0..255), lengths)
    Enum.at(resulting_list, 0) * Enum.at(resulting_list, 1)
  end

  def p2 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    dense_hash(file)
  end
end
