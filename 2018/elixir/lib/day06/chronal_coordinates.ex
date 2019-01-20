defmodule Advent2018.Day6 do
  @moduledoc """
  https://adventofcode.com/2018/day/6

  I watched a little bit of jose valim's video, but now I'm going to try and
  start from here.

  P1 is find the largest bounded space... I believe that everyone who touches
  the bounding box is infinite. (Now that sounds philosophical.)
  """

  @doc ~S"""
      iex> string_to_coord("2, 3")
      {2, 3}
  """
  def string_to_coord(str) do
    str
    |> String.split(", ")
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple
  end

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&string_to_coord/1)
    end
  end

  def manhattan_distance({x1, y1}, {x2, y2}) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  @doc """
  This is an ugly attempt to come up with a set of coords that represent the
  bounds of the map.
  """
  def bounds(list_of_coords) do
    {x_range, y_range} = bounding_box(list_of_coords)

    Enum.map(y_range, &{Enum.min(x_range), &1}) ++
    Enum.map(y_range, &{Enum.max(x_range), &1}) ++
    Enum.map(x_range, &{&1, Enum.min(y_range)}) ++
    Enum.map(x_range, &{&1, Enum.max(y_range)})
    |> Enum.into(MapSet.new)
  end

  def bounding_box(list_of_coords) do
    {{min_x, _}, {max_x, _}} = Enum.min_max_by(list_of_coords, &elem(&1, 0))
    {{_, min_y}, {_, max_y}} = Enum.min_max_by(list_of_coords, &elem(&1, 1))

    {min_x..max_x, min_y..max_y}
  end

  def find_group(point, coordinates) do
    groups =
      coordinates
      |> Enum.map(fn(coord) ->
        {coord, manhattan_distance(point, coord)}
      end)
      |> Enum.sort_by(&elem(&1, 1))
      |> Enum.chunk_by(&elem(&1, 1))
      |> hd

    if Enum.count(groups) > 1 do
      nil
    else
      groups
      |> hd
      |> elem(0)
    end
  end

  def grid(coordinates) do
    {x_range, y_range} = bounding_box(coordinates)

    for x <- x_range,
        y <- y_range,
        point = {x, y},
        do: {point, find_group(point, coordinates)}
  end

  def grid_to_groups(list_of_grouped_coords) do
    list_of_grouped_coords
    |> Enum.reduce(%{}, fn({coord, group}, groups) ->
      Map.update(groups, group, [coord], & [coord|&1])
    end)
    |> Enum.map(fn({key, val}) -> {key, MapSet.new(val)} end)
    |> Enum.into(%{})
  end

  def remove_infinite(map_of_groups, coordinates) do
    Enum.filter(map_of_groups, fn({group, coords}) ->
      MapSet.disjoint?(bounds(coordinates), coords)
    end)
  end

  def find_largest(list_of_groups) do
    Enum.max_by(list_of_groups, & Enum.count(elem(&1, 1)))
  end

  def p1 do
    coordinates = load_input()

    coordinates
    |> grid
    |> grid_to_groups
    |> remove_infinite(coordinates)
    |> find_largest
    |> elem(1)
    |> Enum.count
  end

  def p2 do
  end
end

