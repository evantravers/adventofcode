defmodule Advent2019.Day6 do
  @moduledoc "https://adventofcode.com/2019/day/6"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.reduce(Graph.new, &eval_orbit/2)
    end
  end

  def eval_orbit(string, graph) do
    [a, b] = String.split(string, ")", trim: true)

    Graph.add_edge(graph, a, b)
  end

  def p1(i) do
  end

  def p2(i) do
  end
end
