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

  def p1(input, count \\ 80)
  def p1(input, 0), do: Enum.count(input)
  def p1(input, count) do
    input
    |> Enum.map(&live/1)
    |> List.flatten
    |> p1(count - 1)
  end

  def p2(_i), do: nil
end
