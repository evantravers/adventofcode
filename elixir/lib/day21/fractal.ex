defmodule Advent2017.Day21 do
  @moduledoc """
  You find a program trying to generate some art. It uses a strange process
  that involves repeatedly enhancing the detail of an image through a set of
  rules.

  The image consists of a two-dimensional square grid of pixels that are either
  on (#) or off (.). The program always begins with this pattern:

  .#.
  ..#
  ###

  Because the pattern is both 3 pixels wide and 3 pixels tall, it is said to
  have a size of 3.

  Then, the program repeats the following process:

  If the size is evenly divisible by 2, break the pixels up into 2x2 squares,
  and convert each 2x2 square into a 3x3 square by following the corresponding
  enhancement rule.  Otherwise, the size is evenly divisible by 3; break the
  pixels up into 3x3 squares, and convert each 3x3 square into a 4x4 square by
  following the corresponding enhancement rule.  Because each square of pixels
  is replaced by a larger one, the image gains pixels and so its size
  increases.

  The artist's book of enhancement rules is nearby (your puzzle input);
  however, it seems to be missing rules. The artist explains that sometimes,
  one must rotate or flip the input pattern to find a match. (Never rotate or
  flip the output pattern, though.) Each pattern is written concisely: rows are
  listed as single units, ordered top-down, and separated by slashes. For
  example, the following rules correspond to the adjacent patterns:
  """
end
