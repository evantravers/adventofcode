defmodule Advent2016.Day8 do
  @moduledoc """
  http://adventofcode.com/2016/day/8
  """

  def rect(screen, x, y) do
    for x <- 0..x-1 do
      for y <- 0..y-1 do
        {x, y}
      end
    end
    |> List.flatten
  end

  def rotate(screen, :row, y, offset) do
    {row, remainder} =
      screen
      |> Enum.split_with(fn({_, target}) -> target = y end)

    row
    |> Enum.map(fn({x, y}) -> {x, y + rem(offset, 50)} end)
    |> Kernel.++(remainder)
  end

  def rotate(screen, :column, x, offset) do
    {column, remainder} =
      screen
      |> Enum.split_with(fn({_, target}) -> target = x end)

    column
    |> Enum.map(fn({x, y}) -> {x + rem(offset, 6), y} end)
    |> Kernel.++(remainder)
  end

  def p1, do: nil
  def p2, do: nil
end
