defmodule Advent2023.Day8 do
  @moduledoc "https://adventofcode.com/2023/day/8"

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

  def step(graph, instructions, current \\ "AAA", count \\ 0)
  def step(_graph, _instructions, "ZZZ", count), do: count
  def step(graph, instructions, current, count) do
    direction = get_direction(instructions, count)
    next = Map.get(graph, current) |> direction(direction)

    step(graph, instructions, next, count + 1)
  end

  def p1({steps, graph}) do
    step(graph, steps)
  end

  def p2(_i), do: nil
end
