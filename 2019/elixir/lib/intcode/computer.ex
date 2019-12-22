defmodule Intcode do
  @moduledoc """
  Intcode programs are given as a list of integers; these values are used as
  the initial state for the computer's memory. When you run an Intcode program,
  make sure to start by initializing memory to the program's values. A position
  in memory is called an address (for example, the first value in memory is at
  "address 0").
  """

  use GenServer

  @impl true
  def init(intcode_string, input_pid \\ self(), output_pid \\ self()) do
    {
      :ok,
      intcode_string
      |> load
      |> Map.put(:input_pid, input_pid)
      |> Map.put(:output_pid, output_pid)
    }
  end

  @impl true
  def handle_cast({:set_input, from}, amp) do
    {:noreply, Map.put(amp, :input_pid, from)}
  end
  def handle_cast({:set_output, from}, amp) do
    {:noreply, Map.put(amp, :output_pid, from)}
  end
  def handle_cast(:run, env) do
    env = run(env)
    {:noreply, env}
  end
  def handle_cast({:put_input, input}, amp) do
    {:noreply, put_input(amp, input)}
  end
  def handle_cast({:put_output, output}, amp) do
    {:noreply, put_output(amp, output)}
  end

  @impl true
  def handle_call(:info, _from, amp) do
    {:reply, amp, amp}
  end

  def load_file(file_path) do
    with {:ok, string} <- File.read(file_path) do
      load(string)
    end
  end

  def load(string) do
    %{tape: string_to_tape(string), pointer: 0, output: [], input: []}
    |> update_instruction
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

  I'm currently using a list as a "buffer" to store input... it's stored as
  Map.get(:input) in the main "env" map.
  """
  def inp(env) do
    env
    |> put_in([:tape, elem(Map.get(env, :params), 0)], hd(Map.get(env, :input)))
    |> Map.update!(:input, &tl/1)
    |> Map.update!(:pointer, & &1 + 2)
  end

  @doc """
  Opcode 4 outputs the value of its only parameter. For example, the
  instruction 4,50 would output the value at address 50.
  """
  def out(env) do
    env
    |> put_output(eval_param(env, 0))
    |> Map.update!(:pointer, & &1 + 2)
  end

  def jump_if_true(env) do
    if eval_param(env, 0) != 0 do
      %{env | pointer: eval_param(env, 1)}
    else
      env
      |> Map.update!(:pointer, & &1 + 3)
    end
  end

  def jump_if_false(env) do
    if eval_param(env, 0) == 0 do
      %{env | pointer: eval_param(env, 1)}
    else
      env
      |> Map.update!(:pointer, & &1 + 3)
    end
  end

  def less_than(env = %{params: {_, _, target}}) do
    env
    |> put_in([:tape, target],
      if eval_param(env, 0) < eval_param(env, 1) do
        1
      else
        0
      end
    )
    |> Map.update!(:pointer, & &1 + 4)
  end

  def equals(env = %{params: {_, _, target}}) do
    env
    |> put_in([:tape, target],
      if eval_param(env, 0) == eval_param(env, 1) do
        1
      else
        0
      end
    )
    |> Map.update!(:pointer, & &1 + 4)
  end

  def set_offset(env) do
    env
    |> Map.update(:relative_base, eval_param(env, 0), & &1 + eval_param(env, 0))
    |> Map.update!(:pointer, & &1 + 2)
  end

  def get_value(%{tape: tape}, pointer, 0), do: Map.get(tape, pointer, 0)
  def get_value(_, value, 1), do: value
  def get_value(%{tape: tape, relative_base: base}, pointer, 2) do
    Map.get(tape, base + pointer, 0)
  end

  @doc "Gets the immediate or position value of a parameter by number"
  def eval_param(env = %{params: params, modes: modes}, p_number) do
    get_value(env, elem(params, p_number), elem(modes, p_number))
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
      Map.get(tape, pointer + 1, 0),
      Map.get(tape, pointer + 2, 0),
      Map.get(tape, pointer + 3, 0)
    }

    env
    |> Map.put(:opcode, opcode)
    |> Map.put(:params, params)
    |> Map.put(:modes, modes)
  end

  def put_input(computer = %{input: input}, new_input) do
    %{computer | input: List.insert_at(input, -1, new_input)}
  end

  def put_output(computer = %{output: output}, o) do
    Map.update(computer, :output, [o], &[o|&1])
  end

  def get_output(%{output: [o|_]}), do: o

  @doc """
  Day 2 Tests
      iex> load("1,0,0,0,99")
      ...> |> run
      ...> |> Map.get(:tape)
      ...> |> Map.values
      [2,0,0,0,99]

      iex> load("2,3,0,3,99")
      ...> |> run
      ...> |> Map.get(:tape)
      ...> |> Map.values
      [2,3,0,6,99]

      iex> load("2,4,4,5,99,0")
      ...> |> run
      ...> |> Map.get(:tape)
      ...> |> Map.values
      [2,4,4,5,99,9801]

      iex> load("1,1,1,4,99,5,6,0,99")
      ...> |> run
      ...> |> Map.get(:tape)
      ...> |> Map.values
      [30,1,1,4,2,5,6,0,99]

  Day 5
      iex> load("1002,4,3,4,33")
      ...> |> run
      ...> |> Map.get(:tape)
      ...> |> Map.values
      [1002,4,3,4,99]

      iex> load("3,0,4,0,99")
      ...> |> Map.put(:input, [1337])
      ...> |> run
      ...> |> Map.get(:output)
      ...> |> hd
      1337

  Using position mode, consider whether the input is equal to 8; output 1 (if
  it is) or 0 (if it is not).
      iex> load("3,9,8,9,10,9,4,9,99,-1,8")
      ...> |> Map.put(:input, [1337])
      ...> |> run
      ...> |> Map.get(:output)
      ...> |> hd
      0

  Day 9
      iex> load("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99")
      ...> |> run
      ...> |> Map.get(:output)
      ...> |> Enum.reverse
      [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]

      iex> load("1102,34915192,34915192,7,4,7,99,0")
      ...> |> run
      ...> |> Map.get(:output)
      ...> |> hd
      ...> |> Integer.digits
      ...> |> Enum.count
      16

      iex> load("104,1125899906842624,99")
      ...> |> run
      ...> |> Map.get(:output)
      [1125899906842624]
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
      9 ->
        env
        |> set_offset
        |> update_instruction
        |> run
      99 -> env
      _  -> throw("Unrecognized opcode: #{opcode}")
    end
  end
end
