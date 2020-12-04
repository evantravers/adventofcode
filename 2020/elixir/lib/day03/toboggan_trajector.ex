defmodule Advent2020.Day3 do
  @moduledoc "https://adventofcode.com/2020/day/3"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.reduce(%{}, fn({line, y}, map) ->
        line
        |> String.graphemes
        |> Enum.with_index
        |> Enum.reduce(map, fn({char, x}, map) ->
          Map.put(map, {x, y}, tree?(char))
        end)
      end)
    end
  end

  def tree?("#"), do: true
  def tree?("."), do: false

  def p1(i), do: i
  def p2(_i), do: nil
end
