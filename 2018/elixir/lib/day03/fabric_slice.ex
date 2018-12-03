defmodule Advent2018.Day3 do
  @moduledoc """
  Each Elf has made a claim about which area of fabric would be ideal for Santa's suit. All claims have an ID and consist of a single rectangle with edges parallel to the edges of the fabric. Each claim's rectangle is defined as follows:

  - The number of inches between the left edge of the fabric and the left edge
    of the rectangle.
  - The number of inches between the top edge of the fabric and the top edge of
    the rectangle.
  - The width of the rectangle in inches.
  - The height of the rectangle in inches.

  A claim like #123 @ 3,2: 5x4 means that claim ID 123 specifies a rectangle 3
  inches from the left edge, 2 inches from the top edge, 5 inches wide, and 4
  inches tall. Visually, it claims the square inches of fabric represented by #
  (and ignores the square inches of fabric represented by .) in the diagram
  below:
  """

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&read_line/1)
    end
  end

  def read_line(str) do
    [[_, id, x, y, width, height]] =
      ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
      |> Regex.scan(str)

    %{id: id,
      offset: {String.to_integer(x), String.to_integer(y)},
      size: {String.to_integer(width), String.to_integer(height)}}
  end

  def compute_coords(%{offset: {x_offset, y_offset}, size: {width, height}}) do
    for x <- x_offset..(x_offset + width)-1, y <- y_offset..(y_offset + height)-1 do
      {x, y}
    end
  end

  def p1 do
    load_input()
    |> Enum.map(&compute_coords/1)
    |> List.flatten
    |> Enum.reduce(%{}, fn(coord, list_of_coords) ->
      Map.update(list_of_coords, coord, 1, & &1 + 1)
    end)
    |> Enum.filter(fn({_, count}) -> count > 1 end)
    |> Enum.count
  end

  def p2, do: nil
end
