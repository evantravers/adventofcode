defmodule Advent2018.Day6 do
  @moduledoc """
  https://adventofcode.com/2018/day/6

  My theory:
  - "grow" each start point until I've computed the manhattan distance for each
    point from each point... or I guess I don't need to do that, I can just do
    the math.
  - for each point within bounds, reject all but the lowest distance. If it's
    tied, reject both and it's nil
  - purge anyone on the edges
  - find the largest resulting space
  """

  @bound 500

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
  Given a list of target starting coords, return a map of
  {x, y} => %{group_id => distance}
  """
  def compute_distances(target_coords) do
    for x <- 0..@bound, y <- 0..@bound do
      {{x, y},
        target_coords
        |> Enum.with_index # FIXME: this will be deterministic, but wasteful
        |> Enum.map(fn({coord, group_number}) ->
          {group_number, manhattan_distance(coord, {x, y})}
        end)
      }
    end
  end

  def find_closest_group(distances) do
    possible_winners =
      distances
      |> Enum.sort_by(&elem(&1, 1)) # sort by distance
      |> Enum.chunk_by(&elem(&1, 1)) # chunk by distance
      |> List.first

    if length(possible_winners) > 1 do
      nil
    else
      possible_winners
      |> hd
      |> elem(0) # group number
    end
  end

  def resolve_groups(world) do
    world
    |> Enum.map(fn({coord, distances}) ->
      closest_group = find_closest_group(distances)
      {coord, closest_group}
    end)
  end

  @doc """
  returns a list of group_ids who are on the bounds
  """
  def groups_on_bounds(world) do
    world
    |> Enum.filter(fn({{x, y}, _}) ->
      x == 0 || y == 0 || x == @bound || y == @bound
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.uniq
  end

  def reject_groups_on_bounds(world) do
    bad_groups = groups_on_bounds(world)

    world
    |> Enum.reject(fn({_, id}) ->
      Enum.member?(bad_groups, id)
    end)
  end

  def largest_group_remaining(world) do
    world
    |> Enum.chunk_by(fn({_, id}) -> id end)
    |> Enum.max_by(&Enum.count/1)
    |> Enum.count
  end

  def p1 do
    load_input()
    |> compute_distances
    |> resolve_groups
    |> reject_groups_on_bounds
    |> largest_group_remaining
  end

  def p2 do
  end
end

