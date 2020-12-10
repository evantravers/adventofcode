defmodule Advent2020.Day10 do
  @moduledoc "https://adventofcode.com/2020/day/10"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      # start graph with the outlet
      graph =
        Graph.new
        |> Graph.add_vertex(0)

      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort
      |> Enum.reduce(graph, &parse_adapter/2)
    end
  end

  def possible_adapters(graph, joltage) do
    for jolt <- (joltage - 3)..joltage, Graph.has_vertex?(graph, jolt) do
      {jolt, joltage, label: {:difference, joltage - jolt}}
    end
  end

  def parse_adapter(joltage, graph) do
    graph
    |> Graph.add_vertex(joltage)
    |> Graph.add_edges(possible_adapters(graph, joltage))
  end

  def p1(adapters) do
    device_adapter_joltage =
      adapters
      |> Graph.vertices
      |> Enum.max
      |> Kernel.+(3)

    ordering =
      device_adapter_joltage
      |> parse_adapter(adapters)
      |> Graph.topsort

    score =
      Enum.reduce(ordering, %{ones: 0, threes: 0, last: 0}, fn(num, score) ->
        case num - Map.get(score, :last) do
          1 -> Map.update!(score, :ones, & &1 + 1)
          3 -> Map.update!(score, :threes, & &1 + 1)
          _ -> score
        end
        |> Map.put(:last, num)
      end)

    Map.get(score, :ones) * Map.get(score, :threes)
  end

  def p2(_i), do: nil
end
