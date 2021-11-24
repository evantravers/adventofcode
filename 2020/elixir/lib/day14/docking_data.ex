defmodule Advent2020.Day14 do
  @moduledoc "https://adventofcode.com/2020/day/14"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input") do
      file
      |> String.split("\n", trim: true)
    end
  end

  @doc """
  returns [address, integer]
  """
  def read_memory_instruction(str) do
    ~r/(\d+)] = (\d+)/
    |> Regex.run(str)
    |> tl
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  integer -> charlist representing a 36 bit binary integer
  """
  def to_36bit(integer) do
    integer
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
    |> String.to_charlist
  end

  @doc """
  charlist representing a 36 bit binary integer -> integer
  """
  def to_integer(charlist), do: to_string(charlist) |> String.to_integer(2)

  def set_mask(m, memory), do: Map.put(memory, :mask, String.to_charlist(m))

  def store_mem(instruction, %{mask: mask} = memory) do
    [address, integer] = read_memory_instruction(instruction)

    charlist = to_36bit(integer)

    value =
      Enum.zip_reduce(mask, charlist, [], fn
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
    |> Enum.map(fn({_address, tape}) -> to_integer(tape) end)
    |> Enum.sum
  end

  def write_to_options(list_of_options, value) do
    list_of_options
    |> Enum.map(& &1 ++ [value])
  end

  def address_decoder(instruction, %{mask: mask} = memory) do
    [address, integer] = read_memory_instruction(instruction)

    charlist = to_36bit(address)

    Enum.zip_reduce(mask, charlist, [[]], fn
      (?X, _v, options) -> write_to_options(options, ?1) ++ write_to_options(options, ?0)
      (?0, v, options) -> write_to_options(options, v)
      (?1, _v, options) -> write_to_options(options, ?1)
    end)
    |> Enum.map(fn(num) -> to_integer(num) end)
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
      ("mem[" <> store, memory) -> address_decoder(store, memory)
    end)
    |> Map.delete(:mask)
    |> Enum.map(&elem(&1, 1)) # ignore address, get values
    |> Enum.sum
  end
end
