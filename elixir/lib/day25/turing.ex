defmodule Advent2017.Day25 do
  @moduledoc """
  Following the twisty passageways deeper and deeper into the CPU, you finally
  reach the core of the computer. Here, in the expansive central chamber, you
  find a grand apparatus that fills the entire room, suspended nanometers above
  your head.

  You had always imagined CPUs to be noisy, chaotic places, bustling with
  activity. Instead, the room is quiet, motionless, and dark.

  Suddenly, you and the CPU's garbage collector startle each other. "It's not
  often we get many visitors here!", he says. You inquire about the stopped
  machinery.

  "It stopped milliseconds ago; not sure why. I'm a garbage collector, not a
  doctor." You ask what the machine is for.

  "Programs these days, don't know their origins. That's the Turing machine!
  It's what makes the whole computer work." You try to explain that Turing
  machines are merely models of computation, but he cuts you off. "No, see,
  that's just what they want you to think. Ultimately, inside every CPU,
  there's a Turing machine driving the whole thing! Too bad this one's broken.
  We're doomed!"

  You ask how you can help. "Well, unfortunately, the only way to get the
  computer running again would be to create a whole new Turing machine from
  scratch, but there's no way you can-" He notices the look on your face, gives
  you a curious glance, shrugs, and goes back to sweeping the floor.

  You find the Turing machine blueprints (your puzzle input) on a tablet in a
  nearby pile of debris. Looking back up at the broken Turing machine above,
  you can start to identify its parts:

  A tape which contains 0 repeated infinitely to the left and right.  A cursor,
  which can move left or right along the tape and read or write values at its
  current position.  A set of states, each containing rules about what to do
  based on the current value under the cursor.  Each slot on the tape has two
  possible values: 0 (the starting value for all slots) and 1. Based on whether
  the cursor is pointing at a 0 or a 1, the current state says what value to
  write at the current position of the cursor, whether to move the cursor left
  or right one slot, and which state to use next.
  """

  defmodule Turing do
    @moduledoc "Representing the state of the turing machine"
    defstruct current_state: nil, tape: %{0 => 0}, pointer: 0, states: %{}, checksum: 0, count: 0

    def read_header(turing, header) do
      [_, current, checksum] =
        ~r/Begin in state (?<current>[A-Z]).\nPerform a diagnostic checksum after (?<checksum>\d+) steps./
        |> Regex.run(header)

      %Turing{turing |
        current_state: String.to_atom(current),
        checksum: String.to_integer(checksum)}
    end

    @doc """
    The goal datastructure for the state is:

    {<current state>, %{symbol => [write, move, next]}

    Example:
    {:A, %{0 => [1, 1, :B], 1 => [0, 1, :C]}}
    """
    def read_states(turing, states) do
      states
      |> Enum.map(&new_state &1)
      |> Enum.reduce(turing, fn state, turing ->
        %Turing{turing | states: Map.merge(state, turing.states)}
      end)
    end

    def get_tape(turing) do
      if is_nil(turing.tape[turing.pointer]) do
        0
      else
        turing.tape[turing.pointer]
      end
    end

    def get_checksum(turing) do
      Enum.sum Map.values(turing.tape)
    end

    defp new_state(state_string) do
      [header|transitions] = String.split(state_string, ~r/If.*:/)

      [_, name] = Regex.run(~r/([A-Z]):/, header)

      [zero, one] =
        transitions
        |> Enum.map(&String.trim &1)
        |> Enum.map(fn rules ->
          ~r/\s(\w+|\d+)\.$/m
          |> Regex.scan(rules)
          |> Enum.map(fn [_, v] -> v end)
        end)
        |> Enum.map(&clean_up_rule &1)

      %{String.to_atom(name) => %{0 => zero, 1 => one}}
    end

    defp clean_up_rule([write, direction, next]) do
      dir =
        case direction do
          "left" -> -1
          "right" -> 1
        end
      [String.to_integer(write), dir, String.to_atom(next)]
    end
  end

  def run(m) do
    if m.count == m.checksum do
      m
    else
      [write, offset, next] =
        get_in(m.states, [m.current_state, Turing.get_tape(m)])

      m
      |> Map.update!(:tape, fn t -> Map.put(t, m.pointer, write) end) # write
      |> Map.update!(:pointer, & &1 + offset) # move
      |> Map.put(:current_state, next) # next
      |> Map.update!(:count, & &1 + 1) # count steps
      |> run
    end
  end

  def boot_up_machine(filename) do
    {:ok, file} = File.read(__DIR__ <> "/#{filename}")

    [header|states] = String.split(file, "\n\n", trim: true)

    %Turing{}
    |> Turing.read_header(header)
    |> Turing.read_states(states)
  end

  def p1 do
    machine = boot_up_machine("input.txt")

    machine
    |> run
    |> Turing.get_checksum
  end

  def p2, do: "Merry Christmas!"
end
