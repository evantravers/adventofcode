defmodule Advent2019.Day5 do
  @moduledoc "https://adventofcode.com/2019/day/5"
  @behaviour Advent

  def setup do
    "#{__DIR__}/input.txt"
    |> Intcode.load_input
  end

  def p1(tape) do
    Intcode.run(tape)
  end

  def p2(tape) do
    nil
  end
end
