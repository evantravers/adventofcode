defmodule Advent2021.Day6 do
  @moduledoc "https://adventofcode.com/2021/day/6"

  @lifespan 6

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split(",", trim: true)
      |> Enum.map(fn(i) -> i |> String.trim |> String.to_integer end)
    end
  end

  def live(0), do: [@lifespan, @lifespan + 2]
  def live(int), do: int - 1

  def sim(input, count \\ 80)
  def sim(input, 0), do: Enum.count(input)
  def sim(input, count) do
    input
    |> Enum.map(&live/1)
    |> List.flatten
    |> sim(count - 1)
  end

  def p1(input), do: sim(input, 80)
  def p2(input), do: nil # sim(input, 256)
end
