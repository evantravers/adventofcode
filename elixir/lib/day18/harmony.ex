require IEx

defmodule Advent2017.Day18 do
  @moduledoc """
  You discover a tablet containing some strange assembly code labeled simply
  "Duet". Rather than bother the sound card with it, you decide to run the code
  yourself. Unfortunately, you don't see any documentation, so you're left to
  figure out what the instructions mean on your own.

  It seems like the assembly is meant to operate on a set of registers that are
  each named with a single letter and that can each hold a single integer. You
  suppose each register should start with a value of 0.

  There aren't that many instructions, so it shouldn't be hard to figure out
  what they do. Here's what you determine:

   - snd X plays a sound with a frequency equal to the value of X.

   - set X Y sets register X to the value of Y.

   - add X Y increases register X by the value of Y.

   - mul X Y sets register X to the result of multiplying the value contained
  in register X by the value of Y.

   - mod X Y sets register X to the remainder of dividing the value contained
  in register X by the value of Y (that is, it sets X to the result of X modulo
  Y).

   - rcv X recovers the frequency of the last sound played, but only when the
  value of X is not zero.  (If it is zero, the command does nothing.)

   - jgz X Y jumps with an offset of the value of Y, but only if the value of X
   is greater than zero. (An offset of 2 skips the next instruction, an offset
   of -1 jumps to the previous instruction, and so on.)

  Many of the instructions can take either a register (a single letter) or a
  number. The value of a register is the integer it contains; the value of a
  number is that number.

  After each jump instruction, the program continues with the instruction to
  which the jump jumped. After any other instruction, the program continues
  with the next instruction.  Continuing (or jumping) off either end of the
  program terminates it.
  """

  defmodule Machine do
    @moduledoc "Represents the state of my machine"
    defstruct pointer: 0,
              reg: %{},
              rcv: [],
              snd: [],
              target: self(),
              instructions: [],
              limit: nil,
              parent: nil,
              id: nil

    def put(machine, x, y) do
      Map.update!(machine, :reg, fn reg -> Map.put(reg, String.to_atom(x), y) end)
    end

    defimpl Inspect do
      def inspect(machine, _) do
        "#{machine.id}: #{Kernel.inspect machine.reg}\nSND: #{length machine.snd}"
      end
    end
  end

  @doc ~S"""
  set X Y sets register X to the value of Y.

      iex> set(%Advent2017.Day18.Machine{}, "f", "3")
      %Advent2017.Day18.Machine{reg: %{f: 3}, pointer: 1}

      iex> set(%Advent2017.Day18.Machine{pointer: 0, reg: %{f: 3}}, "x", "f")
      %Advent2017.Day18.Machine{reg: %{f: 3, x: 3}, pointer: 1}
  """
  def set(machine, x, y) do
    machine
    |> Machine.put(x, e(machine, y))
    |> next
  end

  @doc ~S"""
  e evaluates a variable by the stack. If there's a register, it returns that.
  """
  def e(machine, var) do
    cond do
      is_integer(var) ->
        var
      Enum.member?(Map.keys(machine.reg), String.to_atom(var)) ->
        machine.reg[String.to_atom(var)]
      Regex.match?(~r/[a-z]/, var) ->
        0
      true ->
        String.to_integer(var)
    end
  end

  @doc ~S"""
  add X Y increases register X by the value of Y.

      iex> add(%Advent2017.Day18.Machine{pointer: 0, reg: %{f: 3}}, "f", "f")
      %Advent2017.Day18.Machine{reg: %{f: 6}, pointer: 1}
  """
  def add(machine, x, y) do
    machine
    |> Machine.put(x, e(machine, x) + e(machine, y))
    |> next
  end

  @doc ~S"""
  mul X Y sets register X to the result of multiplying the value contained in
  register X by the value of Y.

      iex> mul(%Advent2017.Day18.Machine{pointer: 0, reg: %{f: 3}}, "f", "f")
      %Advent2017.Day18.Machine{reg: %{f: 9}, pointer: 1}
  """
  def mul(machine, x, y) do
    machine
    |> Machine.put(x, e(machine, x) * e(machine, y))
    |> next
  end

  @doc ~S"""
  mod X Y sets register X to the remainder of dividing the value contained in
  register X by the value of Y (that is, it sets X to the result of X modulo
  Y).

      iex> mod(%Advent2017.Day18.Machine{pointer: 0, reg: %{f: 3}}, "f", "2")
      %Advent2017.Day18.Machine{reg: %{f: 1}, pointer: 1}
  """
  def mod(machine, x, y) do
    machine
    |> Machine.put(x, rem(e(machine, x), e(machine, y)))
    |> next
  end

  @doc ~S"""
  snd X sends the value of X to the other program. These values wait in a queue
  until that program is ready to receive them. Each program has its own message
  queue, so a program can never receive a message it sent.

  """
  def snd(machine, x) do
    send(machine.target, e(machine, x))
    machine
    |> Map.update!(:snd, fn history -> [e(machine, x)|history] end)
    |> next
  end

  @doc ~S"""
  rcv X receives the next value and stores it in register X. If no values are
  in the queue, the program waits for a value to be sent to it. Programs do not
  continue to the next instruction until they have received a value. Values are
  received in the order they are sent.

  """
  def rcv(machine, x) do
    receive do
      val ->
        stop_or_next =
          if machine.limit == length(machine.rcv) do
            &stop/1
          else
            &next/1
          end

        machine
        |> Machine.put(x, e(machine, val))
        |> Map.update!(:rcv, fn history -> [e(machine, x)|history] end)
        |> stop_or_next.()
    after
      50 ->
        send(machine.parent, {:deadlock, self(), machine})
        machine
        |> stop
    end
  end

  @doc ~S"""
  jgz X Y jumps with an offset of the value of Y, but only if the value of X
  is greater than zero. (An offset of 2 skips the next instruction, an offset
  of -1 jumps to the previous instruction, and so on.)

      iex> jgz(%Advent2017.Day18.Machine{pointer: 0, reg: %{f: 3}}, "3", "2")
      %Advent2017.Day18.Machine{pointer: 2, reg: %{f: 3}}
      iex> jgz(%Advent2017.Day18.Machine{pointer: 0, reg: %{f: 3}}, "-3", "2")
      %Advent2017.Day18.Machine{pointer: 1, reg: %{f: 3}}
  """
  def jgz(machine, x, y) do
    case e(machine, x) > 0 do
      true  -> Map.update!(machine, :pointer, &(&1 + e(machine, y)))
      false -> next(machine)
    end
  end

  def next(machine), do: Map.update!(machine, :pointer, &(&1 + 1))
  def stop(machine) do
    Map.put(machine, :pointer, 99_999_999_999)
  end

  def setup() do
    receive do
      {:machine, machine} -> run(machine)
    end
  end

  def run(machine) do
    instruction = Enum.at(machine.instructions, machine.pointer)
    if is_nil(instruction) do
      send(machine.parent, {:result, self(), machine})
    else
      [method|args] = String.split(instruction, " ", trim: true)

      run(apply(Advent2017.Day18, String.to_atom(method), [machine | args]))
    end
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    p0 = spawn &setup/0
    machine =
      %Machine{
        limit: 1,
        instructions: String.split(file, "\n", trim: true),
        target: p0,
        parent: self()}

    send(p0, {:machine, machine})

    receive do
      {:result, machine} ->
        machine.rcv
        |> List.first
    end
  end

  def p2 do
    # I guess I'm going to have to spin up some actors and use `send/3` and
    # `receive/1`... let's do some real concurrency!
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    instructions =
      file
      |> String.split("\n", trim: true)

    p0 = spawn &setup/0
    p1 = spawn &setup/0

    machine0 =
      %Machine{
        instructions: instructions,
        reg: %{p: 0},
        target: p1,
        parent: self(),
        id: 0}

    machine1 =
      %Machine{
        instructions: instructions,
        reg: %{p: 1},
        target: p0,
        parent: self(),
        id: 1}

    send(p0, {:machine, machine0})
    send(p1, {:machine, machine1})

    receive do
      {:deadlock, ^p1, machine} ->
        "p#{machine.id}: #{length machine.snd}"
    end
  end
end
