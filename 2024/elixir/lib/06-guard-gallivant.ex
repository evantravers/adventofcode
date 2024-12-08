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

  def obstacle?(lab, coord), do: Map.get(lab, coord) == "#"

  def check({coords, :north}, lab), do: obstacle?(lab, n(coords))
  def check({coords, :east}, lab),  do: obstacle?(lab, e(coords))
  def check({coords, :south}, lab), do: obstacle?(lab, s(coords))
  def check({coords, :west}, lab),  do: obstacle?(lab, w(coords))

  def step({coords, :north}), do: {n(coords), :north}
  def step({coords, :east}),  do: {e(coords), :east}
  def step({coords, :south}), do: {s(coords), :south}
  def step({coords, :west}),  do: {w(coords), :west}

  def walk(guard, lab, steps \\ [])
  def walk(guard, lab, steps) do
    guard
    # if next step has obstable, turn
    # else, step
  end

  def p1({lab, guard}), do: walk(guard, lab)
  def p2(_world), do: nil
end
