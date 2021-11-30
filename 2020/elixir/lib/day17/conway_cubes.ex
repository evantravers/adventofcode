defmodule Advent2020.Day17 do
  @moduledoc "https://adventofcode.com/2020/day/17"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input"), do: setup_string(file)
  end

  def setup_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn({row, y}, state) ->
      row
      |> String.split("", trim: true)
      |> Enum.with_index
      |> Enum.reduce(state, fn({char, x}, state) ->
        Map.put(state, {x, y, 0}, eval_char(char))
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

  def bounding_box(state) do
    {
      min_max(state, 0),
      min_max(state, 1),
      min_max(state, 2)
    }
  end

  def neighbors({x, y, z}) do
    for x <- x-1..x+1, y <- y-1..y+1, z <- z-1..z+1 do
      {x, y, z}
    end
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

  def play(state, count \\ 6)
  def play(state, 0), do: state
  def play(state, count) do
    {
      {min_x, max_x},
      {min_y, max_y},
      {min_z, max_z}
    } = bounding_box(state)

    print(state)

    for x <- min_x..max_x, y <- min_y..max_y, z <- min_z..max_z, into: %{} do
      coord  = {x, y, z}
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
    |> play(count - 1)
  end

  @doc """
      iex> setup_string(".#.
      ...>..#
      ...>###")
      ...> |> p1
      112
  """
  def p1(state) do
    state
    |> play
    |> Enum.count(&elem(&1, 1))
  end

  def p2(_state), do: nil
end
