defmodule Advent2017.Day23 do
  @moduledoc """
  You decide to head directly to the CPU and fix the printer from there. As you
  get close, you find an experimental coprocessor doing so much work that the
  local programs are afraid it will halt and catch fire. This would cause
  serious issues for the rest of the computer, so you head in and see what you
  can do.

  The code it's running seems to be a variant of the kind you saw recently on
  that tablet. The general functionality seems very similar, but some of the
  instructions are different:

  set X Y sets register X to the value of Y.  sub X Y decreases register X by
  the value of Y.  mul X Y sets register X to the result of multiplying the
  value contained in register X by the value of Y.  jnz X Y jumps with an
  offset of the value of Y, but only if the value of X is not zero.  (An offset
  of 2 skips the next instruction, an offset of -1 jumps to the previous
  instruction, and so on.) Only the instructions listed above are used. The
  eight registers here, named a through h, all start at 0.

  The coprocessor is currently set to some kind of debug mode, which allows for
  testing, but prevents it from doing any meaningful work.
  """
  defmodule Machine do
    @moduledoc "Represents the state of my machine"
    defstruct pointer: 0,
              reg: %{},
              instructions: [],
              mul_count: 0

    def put(machine, x, y) do
      Map.update!(machine, :reg, fn reg -> Map.put(reg, String.to_atom(x), y) end)
    end

    defimpl Inspect do
      def inspect(machine, _) do
        "#{Kernel.inspect machine.reg}"
      end
    end
  end

  def next(machine), do: Map.update!(machine, :pointer, &(&1 + 1))
  def stop(machine) do
    Map.put(machine, :pointer, 99_999_999_999)
  end

  @doc ~S"""
  set X Y sets register X to the value of Y.
  """
  def set(machine, x, y) do
    machine
    |> Machine.put(x, e(machine, y))
    |> next
  end

  @doc ~S"""
  mul X Y sets register X to the result of multiplying the value contained in
  register X by the value of Y.
  """
  def mul(machine, x, y) do
    machine
    |> Machine.put(x, e(machine, x) * e(machine, y))
    |> Map.update!(:mul_count, & &1 + 1)
    |> next
  end

  @doc ~S"""
  sub X Y decreases register X by the value of Y.
  """
  def sub(machine, x, y) do
    machine
    |> Machine.put(x, e(machine, x) - e(machine, y))
    |> next
  end

  @doc ~S"""
  jnz X Y jumps with an offset of the value of Y, but only if the value of X is
  not zero. (An offset of 2 skips the next instruction, an offset of -1 jumps
  to the previous instruction, and so on.)
  """
  def jnz(machine, x, y) do
    case e(machine, x) != 0 do
      true  -> Map.update!(machine, :pointer, &(&1 + e(machine, y)))
      false -> next(machine)
    end
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

  def run(machine) do
    instruction = Enum.at(machine.instructions, machine.pointer)
    IO.puts instruction
    IO.inspect machine
    if is_nil(instruction) do
      machine
    else
      [method|args] = String.split(instruction, " ", trim: true)

      run(apply(Advent2017.Day23, String.to_atom(method), [machine | args]))
    end
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    %Machine{instructions: String.split(file, "\n", trim: true)}
    |> run
    |> Map.get(:mul_count)
  end

  def p2 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    %Machine{instructions: String.split(file, "\n", trim: true), reg: %{a: 1}}
    |> run
    |> Map.get(:mul_count)
  end
end
