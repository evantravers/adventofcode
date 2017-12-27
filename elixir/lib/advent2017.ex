defmodule Advent2017 do
  @moduledoc """
  My work for Advent of Code 2017 in elixir this year!

  I started out writing it in random .exs scripts, but now I'm putting it into
  mix so I can use tests.
  """

  def run do
    [
      Advent2017.Day1,
      Advent2017.Day2,
      Advent2017.Day3,
      Advent2017.Day4,
      Advent2017.Day5,
      Advent2017.Day6,
      Advent2017.Day7,
      Advent2017.Day8,
      Advent2017.Day9,
      Advent2017.Day10,
      Advent2017.Day11,
      Advent2017.Day12,
      Advent2017.Day13,
      Advent2017.Day14,
      Advent2017.Day15,
      Advent2017.Day16,
      Advent2017.Day17,
      Advent2017.Day18,
      Advent2017.Day19,
      Advent2017.Day20,
      Advent2017.Day21,
      Advent2017.Day22,
      Advent2017.Day24,
      Advent2017.Day25
    ]
    |> Enum.map(fn(day) ->
      IO.puts "#{day}\n" <>
      "Part 1:\n#{day.p1()}\n" <>
      "Part 2:\n#{day.p2()}\n\n"
    end)
  end
end

defmodule Mix.Tasks.RunAll do
  use Mix.Task

  @shortdoc "Simply runs all the problems from 2017"
  def run(_) do
    Advent2017.run
  end
end

defmodule Mix.Tasks.Day do
  use Mix.Task

  @shortdoc "Run a specific day from the problem set"
  def run(day) do
    IO.puts "Day #{day}: \n" <>
    "Part 1:\n#{apply(String.to_existing_atom("Elixir.Advent2017.Day#{day}"), :p1, [])}\n" <>
    "Part 2:\n#{apply(String.to_existing_atom("Elixir.Advent2017.Day#{day}"), :p2, [])}"
  end
end
