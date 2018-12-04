defmodule Advent2018.Day3 do
  @moduledoc """
  Each Elf has made a claim about which area of fabric would be ideal for
  Santa's suit. All claims have an ID and consist of a single rectangle with
  edges parallel to the edges of the fabric. Each claim's rectangle is defined
  as follows:

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

  @doc """
  results in an id and a description of where the values start and stop.
  """
  def read_line(str) do
    [id, x, y, width, height] =
      ~r/#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/
      |> Regex.scan(str)
      |> List.flatten
      |> tl
      |> Enum.map(&String.to_integer/1)

    %{id: id,
      x_range: (x+1)..(x+width),
      y_range: (y+1)..(y+height)}
  end

  def compute_coords(%{x_range: x_range, y_range: y_range}) do
    for x <- x_range, y <- y_range, do: {x, y}
  end

  @doc ~S"""
  Current not used, doesn't work. I think it'd be a lot faster though.

  FIXME: Figure out what off by one is making this fail
  """
  def overlap?(%{x_range: x_range, y_range: y_range}, target) do
    x_min = Enum.min(target.x_range)
    x_max = Enum.max(target.x_range)

    y_min = Enum.min(target.y_range)
    y_max = Enum.max(target.y_range)

    (Enum.member?(x_range, x_min) || Enum.member?(x_range, x_max))
    &&
    (Enum.member?(y_range, y_min) || Enum.member?(y_range, y_max))
  end

  @doc """
  If the Elves all proceed with their own plans, none of them will have enough
  fabric. How many square inches of fabric are within two or more claims?
  """
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

  @doc """
  What is the ID of the only claim that doesn't overlap?

  I could do this with MapSet.disjoint?/2...

  Or I could try to be clever and ask if it's overlapping based on ranges.
  """
  def p2 do
    claims =
      load_input()
      |> Enum.map(fn(claim) ->
        Map.put(claim, :coords, MapSet.new(compute_coords(claim)))
      end)

    claims
    |> Enum.find(fn(%{coords: coords} = claim) ->
      Enum.all?(List.delete(claims, claim), fn(%{coords: other_coords}) ->
        MapSet.disjoint?(coords, other_coords)
      end)
    end)
    |> Map.get(:id)
  end
end
