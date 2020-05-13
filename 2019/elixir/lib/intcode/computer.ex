defmodule Intcode do
  @moduledoc """
  Intcode programs are given as a list of integers; these values are used as
  the initial state for the computer's memory. When you run an Intcode program,
  make sure to start by initializing memory to the program's values. A position
  in memory is called an address (for example, the first value in memory is at
  "address 0").

  on OUTPUT msg: echo msg


  SPAWN an Intcode module with its source code, set output pid to parent by default.
    on INPUT:
      add to Input queue
      IF halted
        RUN
    on RUN:
      work through opcodes:
        <..>
        Input:
          IF Input queue > 0
           use hd(Input queue)
          ELSE
           halt
        Output:
          send msg to Output pid
  """

  use GenServer

  @impl true
  def init({intcode_string}) do
    {:ok, load(intcode_string)}
  end

  def spawn(intcode_string) do
    with {:ok, pid} <- GenServer.start_link(Intcode, {intcode_string}) do
      pid
    end
  end

  def send_input(pid, msg) do
    GenServer.cast(pid, {:rcv_input, msg})
  end

  def state(pid) do
    with {:ok, state} <- GenServer.call(pid, :state), do: state
  end

  def halted?(pid) do
    with state <- Intcode.state(pid) do
      99 == Map.get(state, :opcode)
    end
  end

  @impl true
  @doc """
  The server is receiving an input from somewhere
  """
  def handle_cast({:rcv_input, input}, state) do
    {:noreply,
      state
      |> put_input(input)
      |> run
    }
  end
  def handle_cast({:set_output_pid, pid}, state) do
    {:noreply, Map.put(state, :output_pid, pid)}
  end

  @impl true
  def handle_call(:state, _, state) do
    {:reply, state, state}
  end

  def load_file(file_path) do
    with {:ok, string} <- File.read(file_path) do
      load(string)
    end
  end

  def load(string) do
    %{tape: string_to_tape(string),
      pointer: 0,
      output: [],
      input: []}
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
  def add(env) do
    env
    |> put(2, get(env, 0) + get(env, 1))
    |> Map.update!(:pointer, & &1 + 4)
  end

  @doc """
  Opcode 2 works exactly like opcode 1, except it multiplies the two inputs
  """
  def mul(env) do
    env
    |> put(2, get(env, 0) * get(env, 1))
    |> Map.update!(:pointer, & &1 + 4)
  end

  @doc """
  Opcode 3 takes a single integer as input and saves it to the position given
  by its only parameter. For example, the instruction 3,50 would take an input
  value and store it at address 50.

  I'm currently using a list as a "buffer" to store input... it's stored as
  Map.get(:input) in the main "env" map.
  """
  def inp(env = %{input: input}) do
    if Enum.empty?(input) do
      env
    else
      env
      |> put(0, hd(Map.get(env, :input)))
      |> Map.update!(:input, &tl/1)
      |> Map.update!(:pointer, & &1 + 2)
      |> update_instruction
      |> run
    end
  end

  @doc """
  Opcode 4 outputs the value of its only parameter. For example, the
  instruction 4,50 would output the value at address 50.
  """
  def out(env) do
    # If I've "wired" two amps together, I need to send the output as input.
    if Map.has_key?(env, :output_pid) do
      GenServer.cast(Map.get(env, :output_pid), {:rcv_input, get(env, 0)})
    end

    env
    |> put_output(get(env, 0))
    |> Map.update!(:pointer, & &1 + 2)
  end

  def jump_if_true(env) do
    if get(env, 0) != 0 do
      %{env | pointer: get(env, 1)}
    else
      env
      |> Map.update!(:pointer, & &1 + 3)
    end
  end

  def jump_if_false(env) do
    if get(env, 0) == 0 do
      %{env | pointer: get(env, 1)}
    else
      env
      |> Map.update!(:pointer, & &1 + 3)
    end
  end

  def less_than(env) do
    env
    |> put(2,
      if get(env, 0) < get(env, 1) do
        1
      else
        0
      end
    )
    |> Map.update!(:pointer, & &1 + 4)
  end

  def equals(env) do
    env
    |> put(2,
      if get(env, 0) == get(env, 1) do
        1
      else
        0
      end
    )
    |> Map.update!(:pointer, & &1 + 4)
  end

  def set_offset(env) do
    env
    |> Map.update(:relative_base, get(env, 0), & &1 + get(env, 0))
    |> Map.update!(:pointer, & &1 + 2)
  end

  def param_mode(env, param_number) do
    env
    |> Map.get(:modes)
    |> elem(param_number)
  end

  def param(env, param_number) do
    env
    |> Map.get(:params)
    |> elem(param_number)
  end

  def get_tape(env, address) do
    env
    |> Map.get(:tape)
    |> Map.get(address, 0)
  end

  def get(env, param_number) do
    mode  = param_mode(env, param_number)
    param = param(env, param_number)

    case mode do
      0 -> get_tape(env, param)
      1 -> param
      2 -> get_tape(env, param + Map.get(env, :relative_base))
    end
  end

  def put(env, param_number, value) do
    mode  = param_mode(env, param_number)
    param = param(env, param_number)

    address =
      case mode do
        0 -> param
        1 -> exit({:error, "Never write in immediate mode!"})
        2 -> param + Map.get(env, :relative_base)
      end

    Map.update!(env, :tape, fn(tape) ->
      Map.put(tape, address, value)
    end)
  end

  @doc """
  set parameter mode, default to 0 (position)
  """
  def pad_to_three(list) do
    if Enum.count(list) == 3 do
      list
    else
      list
      |>Enum.reverse
      |>(&[0|&1]).()
      |>Enum.reverse
      |>pad_to_three
    end
  end

  def update_instruction(env = %{tape: tape, pointer: pointer}) do
    instruction = tape
                  |> Map.get(pointer)
                  |> Integer.digits

    {modes, opcode} = Enum.split(instruction, -2)

    opcode = Integer.undigits(opcode)
    modes = modes
            |>Enum.reverse
            |>pad_to_three
            |>List.to_tuple

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

  def put_output(computer, o) do
    Map.update(computer, :output, [o], &[o|&1])
  end

  def get_last_output(%{output: [o|_]}), do: o

  def get_output(%{output: output}), do: Enum.reverse(output)

  def stop(env) do
    if Map.has_key?(env, :output_pid) do
      Process.exit(self(), {:finished, env})
    end

    env
  end

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
    # IO.puts("p#{Map.get(env, :pointer)}: #{get_in(env, [:tape, Map.get(env, :pointer)])} opcode: #{opcode}")
    case opcode do # opcodes that can halt/pause execution
      99 -> stop(env)
      3 -> inp(env)
      _ ->
        case opcode do # normal opcodes
          1 -> add(env)
          2 -> mul(env)
          4 -> out(env)
          5 -> jump_if_true(env)
          6 -> jump_if_false(env)
          7 -> less_than(env)
          8 -> equals(env)
          9 -> set_offset(env)
          _ -> throw("Unrecognized opcode: #{opcode}")
        end
        |> update_instruction
        |> run
    end
  end
end
