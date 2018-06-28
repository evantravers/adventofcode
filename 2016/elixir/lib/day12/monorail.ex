defmodule Advent2016.Day12 do
  @moduledoc """
  http://adventofcode.com/2016/day/12

  - cpy x y copies x (either an integer or the value of a register) into
    register y.

  - inc x increases the value of register x by one.

  - dec x decreases the value of register x by one.

  - jnz x y jumps to an instruction y away (positive means forward; negative
    means backward), but only if x is not zero.
  """

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(fn(str) ->
        str
        |> String.split(" ")
      end)
      |> Enum.with_index
      |> Enum.map(fn({v, i}) -> {i, v} end)
      |> Enum.into(%{})
    end
  end

  def resolve(state, "a"), do: Map.get(state, :a)
  def resolve(state, "b"), do: Map.get(state, :b)
  def resolve(state, "c"), do: Map.get(state, :c)
  def resolve(state, "d"), do: Map.get(state, :d)
  def resolve(state, num), do: String.to_integer(num)

  def run(state = %{instructions: instructions, pointer: pointer}) do
    # unless the pointer is pointing at nothing
    with instruction when not is_nil(instruction) <- Map.get(instructions, pointer) do
      # on each tick
      # load the instruction at the pointer
      # execute the instruction
      # run `run` on the resulting state
    else
      _ -> state
    end
  end

  def start_state do
    %{a: 0, b: 0, c: 0, d: 0, pointer: 0}
    |> Map.put(:instructions, load_input)
  end

  def p1 do
    start_state()
  end

  def p2 do
    start_state()
    |> Map.put(:c, 1)
  end
end
