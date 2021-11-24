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
    [address, integer] =
      ~r/(\d+)] = (\d+)/
      |> Regex.run(instruction)
      |> tl
      |> Enum.map(&String.to_integer/1)

    bitstring =
      integer
      |> Integer.to_string(2)
      |> String.pad_leading(36, "0")
      |> String.to_charlist

    value =
      Enum.zip_reduce([mask, bitstring], [], fn
        ([?X, v], result) -> result ++ [v]
        ([mask, _v], result) -> result ++ [mask]
      end)

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
    |> Map.delete(:mask)
    |> Enum.map(fn({_address, tape}) ->
      tape
      |> to_string
      |> String.to_integer(2)
    end)
    |> Enum.sum
  end

  def p2(_input), do: nil
end
