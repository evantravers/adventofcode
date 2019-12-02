defmodule Inccode do
  @moduledoc """
  Intcode programs are given as a list of integers; these values are used as
  the initial state for the computer's memory. When you run an Intcode program,
  make sure to start by initializing memory to the program's values. A position
  in memory is called an address (for example, the first value in memory is at
  "address 0").
  """

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

  def load_input(file_path) do
    with {:ok, file} <- File.read(file_path) do
      file
      |> String.split(~r/,|\n/, trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index
      |> Enum.map(fn({a, b}) -> {b, a} end)
      |> Enum.into(%{})
    end
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
end
