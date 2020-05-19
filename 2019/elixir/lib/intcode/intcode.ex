defmodule Intcode do
  alias Intcode.CPU, as: CPU

  @moduledoc """
  Intcode programs are given as a list of integers; these values are used as
  the initial state for the computer's memory. When you run an Intcode program,
  make sure to start by initializing memory to the program's values. A position
  in memory is called an address (for example, the first value in memory is at
  "address 0").

  on OUTPUT msg: echo msg

  SPAWN an Intcode module with its source code, set output pid to parent by
        default.
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

  # ===========================================================================
  # GENSERVER Implementation
  # ===========================================================================
  use GenServer

  @impl true
  def init({intcode_string}) do
    {:ok, CPU.load(intcode_string)}
  end

  @impl true
  @doc "The server is receiving an input from somewhere"
  def handle_cast({:input, input}, state) do
    {:noreply,
      state
      |> CPU.put_input(input)
      |> CPU.run
    }
  end
  def handle_cast({:set_memory, address, value}, state) do
    {:noreply, set_memory(state, address, value)}
  end
  @doc """
  Point the output at another process.
  """
  def handle_cast({:set_output_pid, pid}, state) do
    {:noreply, Map.put(state, :output_pid, pid)}
  end
  def handle_cast(:start, state) do
    {:noreply, start(state)}
  end

  @impl true
  def handle_call(:state, _caller, state) do
    {:reply, state, state}
  end
  def handle_call({:get_memory, address}, _caller, state) do
    {:reply, get_memory(state, address), state}
  end
  def handle_call(:dequeue, _caller, state) do
    {response, new_state} = dequeue(state)
    {:reply, response, new_state}
  end


  # ===========================================================================
  # INTCODE Interface
  # ===========================================================================
  @doc "Spawns a Intcode CPU as a genserver"
  @spec spawn(String.t()) :: pid()
  def spawn(intcode_string) do
    with {:ok, pid} <- GenServer.start_link(Intcode, {intcode_string}) do
      pid
    end
  end

  @doc """
  Send a msg to the input buffer for an Intcode CPU.

  Supports both local and GenServer options.
  """
  def send_input(computer, msg) when is_map(computer) do
    CPU.put_input(computer, msg)
  end
  def send_input(pid, msg) when is_pid(pid) do
    GenServer.cast(pid, {:input, msg})
  end

  @doc "Start the CPU."
  def start(computer) when is_map(computer), do: CPU.run(computer)
  def start(pid) when is_pid(pid), do: GenServer.cast(pid, :start)

  @doc """
  Returns the state of the computer.
  """
  def state(computer) when is_map(computer), do: computer
  def state(pid) when is_pid(pid) do
    with {:ok, state} <- GenServer.call(pid, :state), do: state
  end

  @doc "Change the tape at address with value"
  def set_memory(computer, address, value) when is_map(computer) do
    put_in(computer, [:tape, address], value)
  end
  def set_memory(pid, address, value) when is_pid(pid) do
    GenServer.cast(pid, {:set_memory, address, value})
  end

  @doc "Get the tape at address"
  def get_memory(computer, address) when is_map(computer) do
    get_in(computer, [:tape, address])
  end
  def get_memory(pid, address) when is_map(pid) do
    GenServer.call(pid, {:get_memory, address})
  end

  def dequeue(computer) when is_map(computer) do
    output = Map.get(computer, :output)

    {hd(output), %{computer | output: tl(output)}}
  end
  def dequeue(pid) when is_pid(pid) do
    GenServer.call(pid, :dequeue)
  end

  @doc "Did the program complete?"
  @spec halted?(term) :: boolean()
  def halted?(comp) when is_map(comp), do: Map.get(comp, :opcode) == 99
  def halted?(pid) when is_pid(pid) do
    with state <- Intcode.state(pid) do
      99 == Map.get(state, :opcode)
    end
  end

  def load_file(file_path) do
    with {:ok, string} <- File.read(file_path) do
      Intcode.load_string(string)
    end
  end

  def load_string(string), do: CPU.load(string)

  @doc "Returns a human readable output from the computer."
  def printout(%{output: output}), do: output |> Enum.reverse |> Enum.join(",")
end
