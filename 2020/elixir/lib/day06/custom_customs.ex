defmodule Advent2020.Day6 do
  @moduledoc "https://adventofcode.com/2020/day/6"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n\n", trim: true)
      |> Enum.map(&String.split(&1, "\n", trim: true))
    end
  end

  def count_any(group) do
    group
    |> Enum.reduce(MapSet.new, fn(str, set) ->
      str
      |> String.graphemes
      |> MapSet.new
      |> MapSet.union(set)
    end)
    |> Enum.count
  end

  def count_all(group) do
    group
    |> Enum.reduce(%{}, fn(str, map) ->
      str
      |> String.graphemes
      |> Enum.reduce(map, fn(char, m) ->
        Map.update(m, char, 1, & &1 + 1)
      end)
    end)
    |> Enum.filter(fn({_k, v}) -> v == Enum.count(group) end)
    |> Enum.count
  end

  def p1(groups) do
    groups
    |> Enum.map(&count_any/1)
    |> Enum.sum
  end

  def p2(groups) do
    groups
    |> Enum.map(&count_all/1)
    |> Enum.sum
  end
end
