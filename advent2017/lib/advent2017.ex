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
      Advent2017.Day5
    ]
    |> Enum.map(fn(day) -> 
      IO.puts "Part 1: #{day.p1()}"
      IO.puts "Part 2: #{day.p2()}"
    end)
  end
end
