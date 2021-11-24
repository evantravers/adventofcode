defmodule Advent2020.Day14 do
  @moduledoc "https://adventofcode.com/2020/day/14"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input") do
      file
      |> String.split("\n", trim: true)
    end
  end

  def set_mask(m, memory), do: Map.put(memory, :mask, String.to_charlist(m))

  def store_mem(instruction, %{mask: mask} = memory) do
    # TODO: implement mask
    # TODO: extract address from instruction
    address = 0
    value = 11

    Map.put(memory, address, value)
  end

  @doc ~S"""
      iex> "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
      ...>mem[8] = 11
      ...>mem[7] = 101
      ...>mem[8] = 0"
      ...> |> String.split("\n", trim: true)
      ...> |> p1
      165
  """
  def p1(instructions) do
    instructions
    |> Enum.reduce(%{mask: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'}, fn
      ("mask = " <> mask, memory) -> set_mask(mask, memory)
      ("mem[" <> store, memory) -> store_mem(store, memory)
    end)
    |> Enum.map(fn(tape) ->
      tape
      |> Enum.join
      |> String.to_integer(2)
    end)
    |> Enum.sum
  end

  def p2(_input), do: nil
end
