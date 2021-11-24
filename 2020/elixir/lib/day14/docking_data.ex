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
      Enum.zip_reduce(mask, bitstring, [], fn
        (?X, v, result) -> result ++ [v]
        (mask, _v, result) -> result ++ [mask]
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

  def write_to_options(list_of_options, value) do
    list_of_options
    |> Enum.map(& &1 ++ [value])
  end

  def memory_decoder(instruction, %{mask: mask} = memory) do
    [address, integer] =
      ~r/(\d+)] = (\d+)/
      |> Regex.run(instruction)
      |> tl
      |> Enum.map(&String.to_integer/1)

    bitstring =
      address
      |> Integer.to_string(2)
      |> String.pad_leading(36, "0")
      |> String.to_charlist

    addresses =
      Enum.zip_reduce(mask, bitstring, [[]], fn
        (?X, _v, options) -> write_to_options(options, ?1) ++ write_to_options(options, ?0)
        (?0, v, options) -> write_to_options(options, v)
        (?1, _v, options) -> write_to_options(options, ?1)
      end)
    |> Enum.map(fn(num) ->
      num
      |> to_string
      |> String.to_integer(2)
    end)

    addresses
    |> Enum.reduce(memory, fn(address, memory) ->
      Map.put(memory, address, integer)
    end)
  end

  @doc ~S"""
      iex> "mask = 000000000000000000000000000000X1001X
      ...>mem[42] = 100
      ...>mask = 00000000000000000000000000000000X0XX
      ...>mem[26] = 1"
      ...> |> String.split("\n", trim: true)
      ...> |> p2
      208
  """
  def p2(instructions) do
    instructions
    |> Enum.reduce(%{mask: '000000000000000000000000000000000000'}, fn
      ("mask = " <> mask, memory) -> set_mask(mask, memory)
      ("mem[" <> store, memory) -> memory_decoder(store, memory)
    end)
    |> Map.delete(:mask)
    |> Enum.map(&elem(&1, 1)) # ignore address, get values
    |> Enum.sum
  end
end
