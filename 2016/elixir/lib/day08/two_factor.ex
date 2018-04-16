defmodule Advent2016.Day8 do
  @moduledoc """
  http://adventofcode.com/2016/day/8
  """

  @doc """
  rect AxB turns on all of the pixels in a rectangle at the top-left of the
  screen which is A wide and B tall.
  """
  def rect(screen, a, b) do
  end

  @doc """
  rotate row y=A by B shifts all of the pixels in row A (0 is the top row)
  right by B pixels. Pixels that would fall off the right end appear at the
  left end of the row.
  """
  def rotate(screen, :row, y, b) do
  end

  @doc """
  rotate column x=A by B shifts all of the pixels in column A (0 is the left
  column) down by B pixels. Pixels that would fall off the bottom appear at the
  top of the column.
  """
  def rotate(screen, :column, x, b) do
  end

  def p1, do: nil
  def p2, do: nil
end
