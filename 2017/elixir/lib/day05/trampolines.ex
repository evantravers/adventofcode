defmodule Advent2017.Day5 do
  @moduledoc """
  An urgent interrupt arrives from the CPU: it's trapped in a maze of jump
  instructions, and it would like assistance from any programs with spare
  cycles to help find the exit.

  The message includes a list of the offsets for each jump. Jumps are relative:
  -1 moves to the previous instruction, and 2 skips the next one. Start at the
  first instruction in the list. The goal is to follow the jumps until one
  leads outside the list.

  In addition, these instructions are a little strange; after each jump, the
  offset of that instruction increases by 1. So, if you come across an offset
  of 3, you would move three instructions forward, but change it to a 4 for the
  next time it is encountered.
  """
  def trampoline(list, index, jumps, inc) do
    cond do
      index < 0 ->
        jumps
      index >= map_size(list) ->
        jumps
      true ->
        value  = Map.get(list, index)
        offset = index + value

        list
        |> Map.put(index, inc.(value))
        |> trampoline(offset, jumps + 1, inc)
    end
  end

  def run(inc) do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(&(String.to_integer(&1)))
    |> Enum.with_index
    |> Enum.map(fn({val, ind}) -> {ind, val} end)
    |> Enum.into(%{})
    |> trampoline(0, 0, inc)
  end

  def p1 do
    run(&(&1 + 1))
  end

  def p2 do
    run(&(if &1 >= 3, do: &1 - 1, else: &1 + 1))
  end
end
