defmodule Advent2020.Day10 do
  @moduledoc "https://adventofcode.com/2020/day/10"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sort
      |> Enum.reduce(Graph.new, &parse_adapter/2)
    end
  end

  def possible_adapters(graph, joltage) do
    for jolt <- (joltage - 3)..joltage, Graph.has_vertex?(graph, jolt) do
      {joltage, jolt}
    end
  end

  def parse_adapter(joltage, graph) do
    graph
    |> Graph.add_vertex(joltage)
    |> Graph.add_edges(possible_adapters(graph, joltage))
  end

  def p1(adapters) do
    outlet = %{output: 0}

    device_adapter_joltage =
      adapters
      |> Enum.map(&Map.get(&1, :output))
      |> Enum.max
      |> Kernel.+(3)

    device = %{input: device_adapter_joltage}
  end

  def p2(_i), do: nil
end
