defmodule Advent2023.Day11 do
  @behaviour Advent
  @moduledoc "https://adventofcode.com/2023/day/11"

  def setup do
    with {:ok, file} <- File.read("../input/11") do
      file
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.reduce([], fn {line, y}, world ->
        line
        |> String.codepoints
        |> Enum.with_index
        |> Enum.reduce(world, fn
          {"#", x}, world -> [{x, y}|world]
                _, world  -> world
        end)
      end)
    end
  end

  def p1(world) do
    world
  end
  def p2(_world), do: nil
end
