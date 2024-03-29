defmodule Advent2020.Day17 do
  @moduledoc "https://adventofcode.com/2020/day/17"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input"), do: file
  end

  def setup_world(str, dimensions \\ 3) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn({row, y}, state) ->
      row
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.reduce(state, fn({char, x}, state) ->
        if dimensions == 4 do
          Map.put(state, {x, y, 0, 0}, eval_char(char))
        else
          Map.put(state, {x, y, 0}, eval_char(char))
        end
      end)
    end)
  end

  defp eval_char("#"), do: true
  defp eval_char("."), do: false

  defp min_max(state, v) do
    {min, max} =
      state
      |> Map.keys
      |> Enum.map(fn(coord) -> elem(coord, v) end)
      |> Enum.min_max

    {min - 1, max + 1}
  end

  def bounding_box(state, dimensions \\ 3) do
    0..dimensions-1
    |> Enum.map(&min_max(state, &1))
    |> List.to_tuple
  end

  def neighbors({x, y, z}) do
    for x <- x-1..x+1, y <- y-1..y+1, z <- z-1..z+1 do
      {x, y, z}
    end
    |> List.delete({x, y, z})
  end

  def neighbors({x, y, z, w}) do
    for x <- x-1..x+1, y <- y-1..y+1, z <- z-1..z+1, w <- w-1..w+1 do
      {x, y, z, w}
    end
    |> List.delete({x, y, z, w})
  end

  def neighbors_count(coord, state) do
    coord
    |> neighbors
    |> Enum.map(&Map.get(state, &1, false))
    |> Enum.count(& &1)
  end

  def print(state) do
    {
      {min_x, max_x},
      {min_y, max_y},
      {min_z, max_z}
    } = bounding_box(state)

    for z <- min_z..max_z do
      ["\n\nz=#{z}\n" |
        for y <- min_y..max_y do
          for x <- min_x..max_x do
            if Map.get(state, {x, y, z}) do
              "#"
            else
              "."
            end
          end
          |> Enum.join
          |> Kernel.<>("\n")
        end
      ]
      |> Enum.join
    end
    |> Enum.join
    |> IO.puts

  end

  def apply_rules(coord, state) do
    active = Map.get(state, coord)
    count  = neighbors_count(coord, state)

    if active do
      # If a cube is active and exactly 2 or 3 of its neighbors are also
      # active, the cube remains active. Otherwise, the cube becomes
      # inactive.

      if count == 2 || count == 3 do
        {coord, true}
      else
        {coord, false}
      end
    else
      # If a cube is inactive but exactly 3 of its neighbors are active, the
      # cube becomes active. Otherwise, the cube remains inactive.

      if count == 3 do
        {coord, true}
      else
        {coord, false}
      end
    end
  end

  def play(state, count \\ 6)
  def play(state, 0), do: state
  def play(state, count) do
    {
      {min_x, max_x},
      {min_y, max_y},
      {min_z, max_z}
    } = bounding_box(state)

    # print(state)

    for x <- min_x..max_x, y <- min_y..max_y, z <- min_z..max_z, into: %{} do
      apply_rules({x, y, z}, state)
    end
    |> play(count - 1)
  end

  def play_4d(state, count \\ 6)
  def play_4d(state, 0), do: state
  def play_4d(state, count) do
    {
      {min_x, max_x},
      {min_y, max_y},
      {min_z, max_z},
      {min_w, max_w}
    } = bounding_box(state, 4)

    # print(state)

    for x <- min_x..max_x, y <- min_y..max_y, z <- min_z..max_z, w <- min_w..max_w, into: %{} do
      apply_rules({x, y, z, w}, state)
    end
    |> play_4d(count - 1)
  end

  @doc """
      iex> ".#.
      ...>..#
      ...>###"
      ...> |> p1
      112
  """
  def p1(state) do
    state
    |> setup_world(3)
    |> play
    |> Enum.count(&elem(&1, 1))
  end

  @doc """
      iex> ".#.
      ...>..#
      ...>###"
      ...> |> p2
      848
  """
  def p2(state) do
    state
    |> setup_world(4)
    |> play_4d
    |> Enum.count(&elem(&1, 1))
  end
end
