defmodule Advent2019.Day10 do
  @moduledoc "https://adventofcode.com/2019/day/10"
  @behaviour Advent

  def setup do
    with {:ok, string} <- File.read("#{__DIR__}/input.txt") do
      string
      |> String.split("\n", trim: true)
    end
  end

  def p1(i) do
    i
  end

  def p2(i) do
    i
  end
end
