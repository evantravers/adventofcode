defmodule Advent2016.Day9 do
  @moduledoc """
  http://adventofcode.com/2016/day/9

  The format compresses a sequence of characters. Whitespace is ignored. To
  indicate that some sequence should be repeated, a marker is added to the
  file, like (10x2). To decompress this marker, take the subsequent 10
  characters and repeat them 2 times. Then, continue reading the file after
  the repeated data. The marker itself is not included in the decompressed
  output.

  If parentheses or other characters appear within the data referenced by a
  marker, that's okay - treat it like normal data, not a marker, and then
  resume looking for markers after the decompressed section.
  """

  @doc ~S"""
      iex> decompress("ADVENT")
      6
      iex> decompress("A(1x5)BC")
      7
      iex> decompress("(3x3)XYZ")
      9
      iex> decompress("A(2x2)BCD(2x2)EFG")
      11
      iex> decompress("(6x1)(1x3)A")
      6
      iex> decompress("X(8x2)(3x3)ABCY")
      18
  """
  def decompress(string) do
    string
    |> String.graphemes
    |> decrypt
  end

  def current_multiplier(multipliers) do
    multipliers
    |> Enum.reduce(1, fn({_, multiplier}, total) -> total * multiplier end)
  end

  def decrement(multipliers) do
    multipliers
    |> Enum.map(fn({len, multiplier}) -> {len-1, multiplier} end)
  end

  def decrypt(string, score \\ 0, multipliers \\ [])
  def decrypt([], score, _), do: score
  def decrypt([char|chars], score, multipliers) do
    case char do
      "(" -> # it's a control marker!
        {len, multiplier} = marker(chars)
        marker_length = byte_size("#{len}x#{multiplier})") # skip ahead

        decrypt(Enum.drop(chars, marker_length), score, [{len, multiplier}|multipliers])
      _   -> nil
        decrypt(chars, score + current_multiplier(multipliers), decrement(multipliers))
    end
  end

  @doc ~S"""
  This might be the most offensive function I've ever written. It's very
  opaque:

  1) It goes through the marker, looking for an "x".
  2) Once it finds an "x", it stops, converts that string to an integer, and
     runs itself on the next part of the string.
  3) Once the second copy finds a ")", it stops and returns its integer.
  4) It returns back to the caller which returns the tuple.

      iex> marker(String.graphemes("3x5)"))
      {3, 5}
  """
  def marker(chars, number \\ "")
  def marker([char|chars], number) do
    case char do
      "x" ->
        {String.to_integer(number), marker(chars, "")}
      ")" ->
        String.to_integer(number)
      _   ->
        marker(chars, number <> char)
    end
  end

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input") do
      file
      |> String.replace(~r/\s/, "")
    end
  end

  def p1, do: nil
  def p2 do
    load_input()
    |> decompress
  end
end
