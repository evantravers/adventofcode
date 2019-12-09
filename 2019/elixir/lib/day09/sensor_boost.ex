defmodule Advent2019.Day9 do
  @moduledoc "https://adventofcode.com/2019/day/9"
  @behaviour Advent

  def setup do
    Intcode.load_file("#{__DIR__}/input.txt")
  end

  def p1(machine) do
    machine
    |> Map.put(:input, [1])
    |> Intcode.run
    |> Map.get(:output)
    |> Enum.join(",")
  end

  def p2(i) do
    "not complete"
  end
end
