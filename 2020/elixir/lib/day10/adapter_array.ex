defmodule Advent2020.Day10 do
  @moduledoc "https://adventofcode.com/2020/day/10"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      # start graph with the outlet
      graph =
        Graph.new()
        |> Graph.add_vertex(0)

      adapters =
        file
        |> String.split("\n", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.sort
        |> Enum.reduce(graph, &parse_adapter/2)

      device_adapter_joltage =
        adapters
        |> Graph.vertices
        |> Enum.max
        |> Kernel.+(3)

      # add the device at the end
      parse_adapter(device_adapter_joltage, adapters)
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
    ordering =
      Graph.topsort(adapters)

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

  @spec find_value(Integer, Graph, Map) :: Integer
  def find_value(0, _adapters, _memo), do: 1
  def find_value(node, adapters, memo) do
    if Map.get(memo, node) do
      Map.get(memo, node)
    else
      adapters
      |> Graph.in_neighbors(node)
      |> Enum.map(&find_value(&1, adapters, memo))
      |> Enum.sum
    end
  end

  @doc """
  For each node
  sum the number of solutions that it's parents have, memoize, continue

  I believe that this will only work because it's BFS... and therefore we
  should only be _one_ level deep at any point, so there shouldn't really be
  more than one hop backwards.
  """
  def p2(adapters) do
    adapters
    |> Graph.Reducers.Bfs.reduce(%{}, fn(node, memo) ->
      number_of_parent_options = find_value(node, adapters, memo)

      {:next, Map.put(memo, node, number_of_parent_options)}
    end)
    |> Map.values
    |> Enum.max
  end
end
