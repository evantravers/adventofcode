defmodule Advent2019.Day2 do
  @moduledoc "https://adventofcode.com/2019/day/2"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split(~r/,|\n/, trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index
      |> Enum.map(fn({a, b}) -> {b, a} end)
      |> Enum.into(%{})
    end
  end

  defp operation(tape, position, function) do
    p1     = Map.get(tape, position + 1)
    p2     = Map.get(tape, position + 2)
    target = Map.get(tape, position + 3)

    Map.put(tape, target, function.(Map.get(tape, p1), Map.get(tape, p2)))
  end

  defp add(tape, position) do
    operation(tape, position, &Kernel.+(&1, &2))
  end

  defp mul(tape, position) do
    operation(tape, position, &Kernel.*(&1, &2))
  end

  def run(tape, position) do
    case Map.get(tape, position) do
      1  -> run(add(tape, position), position + 4)
      2  -> run(mul(tape, position), position + 4)
      99 -> Map.get(tape, 0)
      _  -> throw("Unrecognized opcode: #{Map.get(tape, position)}")
    end
  end
  def run(tape), do: run(tape, 0)

  @doc """
  To do this, before running the program, replace position 1 with the value 12
  and replace position 2 with the value 2.
  """
  def p1(input) do
    input
    |> Map.put(1, 12)
    |> Map.put(2, 2)
    |> run
  end

  def p2(input) do
  end
end
