defmodule Intcode do
  @moduledoc """
  Intcode programs are given as a list of integers; these values are used as
  the initial state for the computer's memory. When you run an Intcode program,
  make sure to start by initializing memory to the program's values. A position
  in memory is called an address (for example, the first value in memory is at
  "address 0").
  """

  def load_file(file_path) do
    with {:ok, string} <- File.read(file_path) do
      %{tape: string_to_tape(string), pointer: 0}
      |> update_instruction
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

  @doc """
  Opcode 1 adds together numbers read from two positions and stores the result
  in a third position.
  """
  def add(env = %{params: {_, _, target}}) do
    env
    |> put_in([:tape, target], eval_param(env, 0) + eval_param(env, 1))
    |> Map.update!(:pointer, & &1 + 4)
  end

  @doc """
  Opcode 2 works exactly like opcode 1, except it multiplies the two inputs
  """
  def mul(env = %{params: {_, _, target}}) do
    env
    |> put_in([:tape, target], eval_param(env, 0) * eval_param(env, 1))
    |> Map.update!(:pointer, & &1 + 4)
  end

  @doc """
  Opcode 3 takes a single integer as input and saves it to the position given
  by its only parameter. For example, the instruction 3,50 would take an input
  value and store it at address 50.
  """
  def inp(env = %{tape: tape, input: [input|_], params: {input_pointer, _, _}}) do
    %{env | tape: Map.put(tape, input_pointer, input)}
  end

  @doc """
  Opcode 4 outputs the value of its only parameter. For example, the
  instruction 4,50 would output the value at address 50.
  """
  def out(env = %{params: {p1, _, _}, output: output}) do
    %{env | output: [p1|output]}
  end

  def jump_if_true(env = %{pointer: _}) do
    env
  end

  def jump_if_false(env = %{pointer: _}) do
    env
  end

  def less_than(env = %{pointer: _}) do
    env
  end

  def equals(env = %{pointer: _}) do
    env
  end

  def get_value(tape, pointer, 0), do: Map.get(tape, pointer)
  def get_value(_, value, 1), do: value

  def eval_param(%{tape: tape, params: params, modes: modes}, p_number) do
    get_value(tape, elem(params, p_number), elem(modes, p_number))
  end

  def update_instruction(%{tape: tape, pointer: pointer} = env) do
    instruction = tape
                  |> Map.get(pointer)
                  |> Integer.digits

    opcode = instruction
             |> Enum.split(-2)
             |> elem(1)
             |> Integer.undigits

    # set parameter mode, default to 0 (position)
    modes = {
      Enum.at(instruction, -3, 0),
      Enum.at(instruction, -4, 0),
      Enum.at(instruction, -5, 0)
    }

    params = {
      Map.get(tape, pointer + 1),
      Map.get(tape, pointer + 2),
      Map.get(tape, pointer + 3)
    }

    env
    |> Map.put(:opcode, opcode)
    |> Map.put(:params, params)
    |> Map.put(:modes, modes)
  end

  @doc """
  iex> %{tape: string_to_tape("1,0,0,0,99"), pointer: 0}
  ...> |> update_instruction
  ...> |> run
  ...> |> Map.get(:tape)
  ...> |> Map.values
  [2,0,0,0,99]

  iex> %{tape: string_to_tape("2,3,0,3,99"), pointer: 0}
  ...> |> update_instruction
  ...> |> run
  ...> |> Map.get(:tape)
  ...> |> Map.values
  [2,3,0,6,99]

  iex> %{tape: string_to_tape("2,4,4,5,99,0"), pointer: 0}
  ...> |> update_instruction
  ...> |> run
  ...> |> Map.get(:tape)
  ...> |> Map.values
  [2,4,4,5,99,9801]

  iex> %{tape: string_to_tape("1,1,1,4,99,5,6,0,99"), pointer: 0}
  ...> |> update_instruction
  ...> |> run
  ...> |> Map.get(:tape)
  ...> |> Map.values
  [30,1,1,4,2,5,6,0,99]
  """
  def run(env = %{opcode: opcode}) do
    case opcode do
      1 ->
        env
        |> add
        |> update_instruction
        |> run
      2 ->
        env
        |> mul
        |> update_instruction
        |> run
      3 ->
        env
        |> inp
        |> update_instruction
        |> run
      4 ->
        env
        |> out
        |> update_instruction
        |> run
      5 ->
        env
        |> jump_if_true
        |> update_instruction
        |> run
      6 ->
        env
        |> jump_if_false
        |> update_instruction
        |> run
      7 ->
        env
        |> less_than
        |> update_instruction
        |> run
      8 ->
        env
        |> equals
        |> update_instruction
        |> run
      99 -> env
      _  -> throw("Unrecognized opcode: #{opcode}")
    end
  end
end
