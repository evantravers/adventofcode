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
  def decompress(string), do: nil

  def p1, do: nil
  def p2, do: nil
end
