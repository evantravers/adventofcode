defmodule Advent2015.Day7 do
  @moduledoc """
  Each wire has an identifier (some lowercase letters) and can carry a 16-bit
  signal (a number from 0 to 65535). A signal is provided to each wire by a
  gate, another wire, or some specific value. Each wire can only get a signal
  from one source, but can provide its signal to multiple destinations. A gate
  provides no signal until all of its inputs have a signal.

  The included instructions booklet describes how to connect the parts
  together: x AND y -> z means to connect wires x and y to an AND gate, and
  then connect its output to wire z.
  """

  use Bitwise

  def load_input do
    {:ok, file} = File.read("#{__DIR__}/input.txt")

    file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
  end

  def e(state, x) do
    if Map.has_key?(state, x) do
      Map.get(state, x)
    else
      (fn -> Map.get(state, x) end) # A promise to be delivered later
    end
  end

  @doc """
  123 -> x means that the signal 123 is provided to wire x.
  """
  def cmd(state, [val, "->", target]), do: Map.put(state, target, val)

  @doc """
  x AND y -> z means that the bitwise AND of wire x and wire y is provided to
  wire z.
  """
  def cmd(state, [x, "AND", y, "->", target]) do
    Map.put(state, target, band(e(state, x), e(state, y)))
  end
  def cmd(state, [x, "OR", y, "->", target]) do
    Map.put(state, target, bor(e(state, x), e(state, y)))
  end

  @doc """
  p LSHIFT 2 -> q means that the value from wire p is left-shifted by 2 and
  then provided to wire q.
  """
  def cmd(state, [wire, "LSHIFT", amt, "->", target]) do
    Map.put(state, target, bsl(e(state, wire), amt))
  end
  def cmd(state, [wire, "RSHIFT", amt, "->", target]) do
    Map.put(state, target, bsr(e(state, wire), amt))
  end

  @doc """
  NOT e -> f means that the bitwise complement of the value from wire e is
  provided to wire f.
  """
  def cmd(state, ["NOT", wire, "->", target]) do
    Map.put(state, target, bnot(e(state, wire)))
  end

  def p1 do
    load_input()
    |> Enum.reduce(%{}, fn instruction, state -> cmd(state, instruction) end)
  end

  def p2, do: nil
end
