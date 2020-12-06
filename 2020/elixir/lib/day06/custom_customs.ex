defmodule Advent2020.Day6 do
  @moduledoc "https://adventofcode.com/2020/day/6"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))
    end
  end

  def count_freq(group) do
    group
    |> Enum.reduce(MapSet.new, fn(str, set) ->
      str
      |> String.graphemes
      |> MapSet.new
      |> MapSet.union(set)
    end)
    |> Enum.count
  end

  def p1(groups) do
    groups
    |> Enum.map(&count_freq/1)
    |> Enum.sum
  end

  def p2(_i), do: nil
end
