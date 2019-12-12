defmodule Advent2019.Day12 do
  @moduledoc "https://adventofcode.com/2019/day/12"
  @behaviour Advent

  def setup do
    with {:ok, string} <- File.read("#{__DIR__}/input.txt") do
      string
      |> String.split("\n", trim: true)
      |> Enum.map(&new_moon/1)
    end
  end

  def new_moon(str) do
    [x, y, z] =
      ~r/-*\d+/
      |> Regex.scan(str)
      |> List.flatten
      |> Enum.map(&String.to_integer/1)

    %{pos: {x, y, z}, vel: {0, 0, 0}}
  end

  def p1(i) do
    i
  end

  def p2(i) do
    i
  end
end
