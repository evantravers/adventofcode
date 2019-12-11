defmodule Advent2019.Day10 do
  @moduledoc "https://adventofcode.com/2019/day/10"
  @behaviour Advent

  def setup do
    with {:ok, string} <- File.read("#{__DIR__}/input.txt") do
      process_map(string)
    end
  end

  @spec process_map(String.t) :: MapSet.t
  def process_map(string) do
    rows =
      string
      |> String.split("\n", trim: true)
      |> Enum.with_index

    for {row, y} <- rows,
        {char, x} <- Enum.with_index(String.graphemes(row)),
        char == "#" do
      {x, y}
    end
    |> MapSet.new
  end

  def p1(i) do
    i
  end

  def p2(i) do
    i
  end
end
