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

  @doc """
  Read in a rule from a string and generate a map with every possible matching
  rule leading to the same result pattern
  """
  def rule(rule_string, rules \\ %{}) do
    [pattern, result] =
      String.split(rule_string, " => ", trim: true)
      |> Enum.map(&to_grid &1)

    all_combinations(pattern)

  end

  @doc """
  Takes in the format of the rule, outputs a two dimensional array of booleans.

  TODO: I think I'd like to explore doing this in place... in a single array
  possibly. Can we rotate and flip w/out transforming the 1d array into 2d?
  """
  def to_grid(str) do
    String.split(str, "/", trim: true)
    |> Enum.map(fn substr ->
      String.split(substr, "", trim: true)
      |> Enum.map(& &1 == "#")
    end)
  end

  def flip(grid) do
    Enum.map(grid, fn row -> Enum.reverse(row) end)
  end

  @doc """
  Rotates the grid 90 degrees clockwise using a transpose and a flip. Is there
  a better way? Maybe.

  By default, rotates 1 time, you can provide an integer (1-3) to keep
  rotating.
  """
  def rotate(grid, num \\ 1)
  def rotate(grid, num) when num == 0, do: grid
  def rotate(grid, num) when num > 0 do
    flip(List.zip(grid) |> Enum.map(&Tuple.to_list(&1)))
    |> rotate(num-1)
  end

  def all_combinations(grid) do
    Enum.map((0..3), fn int -> [rotate(grid, int), flip(rotate(grid, int))] end)
    |> Enum.reduce(&Enum.concat(&1, &2))
  end

  def print(grid) do
    Enum.map(grid, fn row ->
      Enum.map(row, fn col ->
        case col do
           true -> "#"
          false -> "."
        end
      end)
      |> Enum.join
      |> Kernel.<>("\n")
    end)
    |> Enum.join
  end
end
