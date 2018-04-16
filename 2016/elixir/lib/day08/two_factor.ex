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

  def display(screen) do
    for y <- 0..screen.y-1 do
      for x <- 0..screen.x-1 do
        case get_in(screen, [y, x]) do
          true  -> "#"
          false -> "."
        end
      end
      |> Enum.join
      |> Kernel.<> "\n"
    end
    |> Enum.join
  end

  @doc "builds a map of maps of size x, y"
  def screen(x, y) do
    for y <- 0..y-1, into: %{} do
      {y, (for x <- 0..x-1, into: %{}, do: {x, false})}
    end
    |> Map.put(:x, x)
    |> Map.put(:y, y)
  end

  def test do
  end

  def p1, do: nil
  def p2, do: nil
end
