defmodule Intcode do
  @moduledoc """
  Intcode programs are given as a list of integers; these values are used as
  the initial state for the computer's memory. When you run an Intcode program,
  make sure to start by initializing memory to the program's values. A position
  in memory is called an address (for example, the first value in memory is at
  "address 0").
  """

  @doc """
  0:
  position mode, which causes the parameter to be interpreted as a position

  - if the parameter is 50, its value is the value stored at address 50 in
    memory.

  1:
  immediate mode. In immediate mode, a parameter is interpreted as a value

  - if the parameter is 50, its value is simply 50.

      iex> parameter_mode(%{0 => 10, 1 => 20}, {:pos, 0})
      10

      iex> parameter_mode(%{0 => 10, 1 => 20}, {:imm, 0})
      0
  """
  def parameter_mode(tape, {:pos, target}), do: Map.get(tape, target)
  def parameter_mode(_, {:imm, value}), do: value

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result
  in a third position.
  """
  def add(tape, arg1, arg2, target) do
    tape
    |> Map.put(target, parameter_mode(tape, arg1) + parameter_mode(tape, arg2))
  end

  @doc """
  Opcode 2 works exactly like opcode 1, except it multiplies the two inputs
  """
  def mul(tape, arg1, arg2, target) do
    tape
    |> Map.put(target, parameter_mode(tape, arg1) * parameter_mode(tape, arg2))
  end

  @doc """
  Opcode 3 takes a single integer as input and saves it to the position given
  by its only parameter. For example, the instruction 3,50 would take an input
  value and store it at address 50.
  """
  def inp(tape, target) do
    Map.put(tape, target, 1) # Part 1 only takes a 1!
  end

  @doc """
  Opcode 4 outputs the value of its only parameter. For example, the
  instruction 4,50 would output the value at address 50.
  """
  def out(tape, arg1) do
    tape
    |> Map.get(parameter_mode(tape, arg1))
    |> IO.puts

    tape
  end

  def load_input(file_path) do
    with {:ok, file} <- File.read(file_path) do
      string_to_tape(file)
    end
  end

  def string_to_tape(string) do
    string
    |> String.split(~r/,|\n/, trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index
    |> Enum.map(fn({a, b}) -> {b, a} end)
    |> Enum.into(%{})
  end

  defp convert_to_mode(0), do: :pos
  defp convert_to_mode(1), do: :imm

  def run(tape, position) do
    instruction =
      tape
      |> Map.get(position)
      |> Integer.digits

    opcode = instruction
             |> Enum.split(-2)
             |> elem(1)
             |> Integer.undigits

    # set parameter mode, default to 0 (position)
    arg1_mode = instruction
                |> Enum.at(-3, 0)
                |> convert_to_mode
    arg2_mode = instruction
                |> Enum.at(-4, 0)
                |> convert_to_mode

    arg1 = Map.get(tape, position + 1)
    arg2 = Map.get(tape, position + 2)
    arg3 = Map.get(tape, position + 3)

    case opcode do
      1 ->
        tape
        |> add({arg1_mode, arg1}, {arg2_mode, arg2}, arg3)
        |> run(position + 4)
      2 ->
        tape
        |> mul({arg1_mode, arg1}, {arg2_mode, arg2}, arg3)
        |> run(position + 4)
      3 -> run(inp(tape, arg1), position + 2)
      4 -> run(out(tape, {arg1_mode, arg1}), position + 2)
      99 -> Map.get(tape, 0)
      _  -> throw("Unrecognized opcode: #{Map.get(tape, position)}")
    end
  end
  def run(tape), do: run(tape, 0)
end
