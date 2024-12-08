defmodule Advent2024.Day6 do
  @moduledoc "https://adventofcode.com/2024/day/6"

  def setup do
    with {:ok, file} <- File.read("../input/6") do
      lab =
      file
        |> String.split("\n", trim: true)
        |> Enum.with_index
        |> Enum.reduce(%{}, fn {line, y}, map ->
          line
          |> String.graphemes
          |> Enum.with_index
          |> Enum.reduce(map, fn
            {"^", x}, map ->
              map
              |> Map.put(:guard, {{x, y}, :north})
              |> Map.put({x, y}, ".")
            {char, x}, map -> Map.put(map, {x, y}, char)
          end)
        end)

      {Map.delete(lab, :guard), Map.get(lab, :guard)}
    end
  end

  def turn({coords, :north}), do: {coords, :east}
  def turn({coords, :east}), do: {coords, :south}
  def turn({coords, :south}), do: {coords, :west}
  def turn({coords, :west}), do: {coords, :north}

  def n({x, y}), do: {x, y + 1}
  def s({x, y}), do: {x, y - 1}
  def e({x, y}), do: {x + 1, y}
  def w({x, y}), do: {x - 1, y}

  def hash?(lab, coord), do: Map.get(lab, coord) == "#"

  def obstacle?({coords, :north}, lab), do: hash?(lab, n(coords))
  def obstacle?({coords, :east}, lab),  do: hash?(lab, e(coords))
  def obstacle?({coords, :south}, lab), do: hash?(lab, s(coords))
  def obstacle?({coords, :west}, lab),  do: hash?(lab, w(coords))

  def step({coords, :north}), do: {n(coords), :north}
  def step({coords, :east}),  do: {e(coords), :east}
  def step({coords, :south}), do: {s(coords), :south}
  def step({coords, :west}),  do: {w(coords), :west}

  def walk(guard, lab, steps \\ [])
  def walk({coords, _dir} = guard, lab, steps) do
    cond do
      obstacle?(guard, lab) ->
        guard
        |> turn
        |> walk(lab, steps)
      is_nil(Map.get(lab, coords)) ->
        steps
      true ->
        guard
        |> step
        |> walk(lab, [coords|steps])
    end
  end

  def p1({lab, guard}) do
    guard
    |> walk(lab)
    |> Enum.uniq
    |> Enum.count
  end
  def p2(_world), do: nil
end
