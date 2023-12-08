defmodule Advent2023.Day8 do
  @moduledoc "https://adventofcode.com/2023/day/8"

  require Math

  def setup do
    with {:ok, file} <- File.read("../input/8") do
      setup_from_string(file)
    end
  end

  def setup_from_string(str) do
    [steps, graph] = String.split(str, "\n\n", trim: true)

    {
      steps
      |> String.codepoints
      |> Enum.map(&String.to_atom/1),
      graph
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn(str, graph) ->
        [key, left, right] = Regex.scan(~r/\w+/, str) |> List.flatten

        Map.put(graph, key, {left, right})
      end)
    }
  end

  def direction({left, _right}, :L), do: left
  def direction({_left, right}, :R), do: right

  def get_direction(instructions, count) do
    Enum.at(instructions, Integer.mod(count, Enum.count(instructions)))
  end

  def step(graph, instructions, current, target, count \\ 0)
  def step(graph, instructions, current, target, count) do
    if Regex.match?(target, current) do
      count
    else
      direction = get_direction(instructions, count)
      next = Map.get(graph, current) |> direction(direction)

      step(graph, instructions, next, target, count + 1)
    end
  end

  def p1({steps, graph}) do
    step(graph, steps, "AAA", ~r/ZZZ/)
  end

  def p2({steps, graph}) do
    graph
    |> Map.keys
    |> Enum.filter(fn str -> String.match?(str, ~r/\w\wA/) end)
    |> Enum.map(fn ghost ->
      step(graph, steps, ghost, ~r/\w\wZ/)
    end)
    |> Enum.reduce(fn(num, acc) ->
      Math.lcm(num, acc)
    end)
  end
end
