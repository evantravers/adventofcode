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
              |> Map.put(:guard, {x, y, :north})
              |> Map.put({x, y}, ".")
            {char, x}, map -> Map.put(map, {x, y}, char)
          end)
        end)

      {Map.delete(lab, :guard), Map.get(lab, :guard)}
    end
  end

  def turn({x, y, :north}), do: {x, y, :east}
  def turn({x, y, :east}), do: {x, y, :south}
  def turn({x, y, :south}), do: {x, y, :west}
  def turn({x, y, :west}), do: {x, y, :north}

  def p1{_lab, guard} do
    guard
  end
  def p2(_world), do: nil
end
