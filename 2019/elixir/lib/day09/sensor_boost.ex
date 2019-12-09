defmodule Advent2019.Day9 do
  @moduledoc "https://adventofcode.com/2019/day/9"
  @behaviour Advent

  def setup do
    Intcode.load_file("#{__DIR__}/input.txt")
  end

  def p1(machine) do
    machine
    |> Intcode.run
    |> Map.get(:output)
    |> hd
  end

  def p2(i) do
    i
  end
end
