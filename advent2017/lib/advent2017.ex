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
      Advent2017.Day8,
      Advent2017.Day9
    ]
    |> Enum.map(fn(day) ->
      IO.puts "#{day}\n" <>
      "Part 1:\n#{day.p1()}\n" <>
      "Part 2:\n#{day.p2()}\n\n"
    end)
  end
end

defmodule Mix.Tasks.RunDays do
  use Mix.Task

  @shortdoc "Simply runs all the problems from 2017"
  def run(_) do
    # calling our Hello.say() function from earlier
    Advent2017.run
  end
end
