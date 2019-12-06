defmodule Advent2019.Day5 do
  @moduledoc "https://adventofcode.com/2019/day/5"
  @behaviour Advent

  def setup do
    "#{__DIR__}/input.txt"
    |> Intcode.load_file
  end

  def p1(tape) do
    tape
    |> Map.put(:input, [1])
    |> Intcode.run
    |> Map.get(:output)
    |> hd
  end

  def p2(tape) do
    tape
    |> Intcode.run
    |> Map.get(:output)
    |> hd
  end
end
