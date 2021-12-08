defmodule Advent2021.Day6 do
  @moduledoc "https://adventofcode.com/2021/day/6"

  @lifespan 6

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split(",", trim: true)
      |> Enum.map(fn(int) ->
        int
        |> String.trim
        |> String.to_integer
      end)
      |> Enum.frequencies
    end
  end

  def tick({0, count}), do: [{@lifespan, count}, {@lifespan + 2, count}]
  def tick({clock, count}), do: {clock - 1, count}

  def sim(fish, 0), do: fish |> Enum.map(fn({_clock, count}) -> count end) |> Enum.sum
  def sim(fish, countdown) do
    fish
    |> Enum.map(&tick/1)
    |> List.flatten
    |> sim(countdown - 1)
  end

  def p1(input), do: sim(input, 80)
  def p2(input), do: sim(input, 256)
end
