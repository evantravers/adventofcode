defmodule Advent2021.Day12 do
  @behaviour Advent
  @moduledoc "https://adventofcode.com/2021/day/12"

  def setup do
    with {:ok, input} <- File.read("#{__DIR__}/input.txt") do
      input
      |> String.split("\n", trim: true)
      |> Enum.reduce(Graph.new, fn(str, graph) ->
        [a, b] = String.split(str, "-", trim: true)

        Graph.add_edge(graph, a, b)
      end)
    end
  end

  @doc """
  Visiting small caves only once per path, big caves more than once.

  I wonder if this could be done by deleting the small caves out of the graph
  once they have been found.
  """
  def p1(graph) do
    graph
  end

  def p2(_i), do: nil
end
