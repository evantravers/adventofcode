defmodule Intcode do
  @moduledoc """
  Intcode programs are given as a list of integers; these values are used as
  the initial state for the computer's memory. When you run an Intcode program,
  make sure to start by initializing memory to the program's values. A position
  in memory is called an address (for example, the first value in memory is at
  "address 0").
  """

  defp operation(tape, position, function, :immediate) do
    arg1   = Map.get(tape, position + 1)
    arg2   = Map.get(tape, position + 2)
    target = Map.get(tape, position + 3)

    Map.put(tape, target, function.(arg1, arg2))
  end

  defp operation(tape, position, function, :position) do
    arg1   = Map.get(tape, position + 1)
    arg2   = Map.get(tape, position + 2)
    target = Map.get(tape, position + 3)

    Map.put(tape, target, function.(Map.get(tape, arg1), Map.get(tape, arg2)))
  end

  defp add(tape, position) do
    operation(tape, position, &Kernel.+(&1, &2), :position)
  end

  defp mul(tape, position) do
    operation(tape, position, &Kernel.*(&1, &2), :position)
  end

  defp inp(tape, position) do
  end

  defp out(tape, position) do
  end

  defp imm() do
  end

  defp pos() do
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
    args =
      tape
      |> Map.get(position)
      |> Integer.digits

    opcode    = args
                |> Enum.reverse_slice(0, 2)
                |> Integer.undigits
    arg1_mode = Enum.at(args, -3)
    arg2_mode = Enum.at(args, -4)

    case opcode do
      1  -> run(add(tape, position), position + 4)
      2  -> run(mul(tape, position), position + 4)
      3  -> run(inp(tape, position), position + 2)
      4  -> run(out(tape, position), position + 2)
      99 -> Map.get(tape, 0)
      _  -> throw("Unrecognized opcode: #{Map.get(tape, position)}")
    end
  end
  def run(tape), do: run(tape, 0)
end
