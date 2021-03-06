defmodule Advent2018.Day16 do
  use Bitwise

  @moduledoc """
  https://adventofcode.com/2018/day/16

  Every instruction consists of four values: an opcode, two inputs (named A and
  B), and an output (named C), in that order. The opcode specifies the behavior
  of the instruction and how the inputs are interpreted. The output, C, is
  always treated as a register.

  In the opcode descriptions below, if something says "value A", it means to
  take the number given as A literally. (This is also called an "immediate"
  value.) If something says "register A", it means to use the number given as A
  to read from (or write to) the register with that number. So, if the opcode
  addi adds register A and value B, storing the result in register C, and the
  instruction addi 0 7 3 is encountered, it would add 7 to the value contained
  by register 0 and store the sum in register 3, never modifying registers 0,
  1, or 2 in the process.
  """

  @ops [:addr, :addi,
        :mulr, :muli,
        :banr, :bani,
        :borr, :bori,
        :setr, :seti,
        :gtir, :gtri, :gtrr,
        :eqir, :eqri, :eqrr]

  def get(state, reg), do: Map.get(state, reg, 0)

  @doc ~S"""
      iex> [1, 2, 3, 4] |> to_state()
      %{0 => 1, 1 => 2, 2 => 3, 3 => 4}
  """
  def to_state(list) do
    list
    |> Enum.with_index
    |> Enum.map(fn({val, ind}) -> {ind, val} end)
    |> Enum.into(%{})
  end

  @doc """
  addr (add register)
  stores into register C the result of adding register A and register B.
  """
  def addr(state, [a, b, c]) do
    Map.put(state, c, get(state, a) + get(state, b))
  end

  @doc """
  addi (add immediate)
  stores into register C the result of adding register A and value B.
  """
  def addi(state, [a, b, c]) do
    Map.put(state, c, get(state, a) + b)
  end

  @doc """
  mulr (multiply register)
  stores into register C the result of multiplying register A and register B.
  """
  def mulr(state, [a, b, c]) do
    Map.put(state, c, get(state, a) * get(state, b))
  end

  @doc """
  muli (multiply immediate)
  stores into register C the result of multiplying register A and value B.
  """
  def muli(state, [a, b, c]) do
    Map.put(state, c, get(state, a) * b)
  end

  @doc """
  banr (bitwise AND register)
  stores into register C the result of the bitwise AND of register A and
  register B.
  """
  def banr(state, [a, b, c]) do
    Map.put(state, c, get(state, a) &&& get(state, b))
  end

  @doc """
  bani (bitwise AND immediate)
  stores into register C the result of the bitwise AND of register A and value
  B.
  """
  def bani(state, [a, b, c]) do
    Map.put(state, c, get(state, a) &&& b)
  end

  @doc """
  borr (bitwise OR register)
  stores into register C the result of the bitwise OR of register A and
  register B.
  """
  def borr(state, [a, b, c]) do
    Map.put(state, c, get(state, a) ||| get(state, b))
  end

  @doc """
  bori (bitwise OR immediate)
  stores into register C the result of the bitwise OR of register A and value
  B.
  """
  def bori(state, [a, b, c]) do
    Map.put(state, c, get(state, a) ||| b)
  end

  @doc """
  setr (set register)
  copies the contents of register A into register C. (Input B is ignored.)
  """
  def setr(state, [a, _, c]) do
    Map.put(state, c, get(state, a))
  end

  @doc """
  seti (set immediate)
  stores value A into register C. (Input B is ignored.)
  """
  def seti(state, [a, _, c]) do
    Map.put(state, c, a)
  end

  @doc """
  gtir (greater-than immediate/register)
  sets register C to 1 if value A is greater than register B.
  Otherwise, register C is set to 0.
  """
  def gtir(state, [a, b, c]) do
    Map.put(state, c,
      if a > get(state, b) do
        1
      else
        0
      end
    )
  end

  @doc """
  gtri (greater-than register/immediate)
  sets register C to 1 if register A is greater than value B.
  Otherwise, register C is set to 0.
  """
  def gtri(state, [a, b, c]) do
    Map.put(state, c,
      if get(state, a) > b do
        1
      else
        0
      end
    )
  end

  @doc """
  gtrr (greater-than register/register)
  sets register C to 1 if register A is greater than register B.
  Otherwise, register C is set to 0.
  """
  def gtrr(state, [a, b, c]) do
    Map.put(state, c,
      if get(state, a) > get(state, b) do
        1
      else
        0
      end
    )
  end

  @doc """
  eqir (equal immediate/register)
  sets register C to 1 if value A is equal to register B.
  Otherwise, register C is set to 0.
  """
  def eqir(state, [a, b, c]) do
    Map.put(state, c,
      if a == get(state, b) do
        1
      else
        0
      end
    )
  end

  @doc """
  eqri (equal register/immediate)
  sets register C to 1 if register A is equal to value B.
  Otherwise, register C is set to 0.
  """
  def eqri(state, [a, b, c]) do
    Map.put(state, c,
      if get(state, a) == b do
        1
      else
        0
      end
    )
  end

  @doc """
  eqrr (equal register/register)
  sets register C to 1 if register A is equal to register B.
  Otherwise, register C is set to 0.
  """
  def eqrr(state, [a, b, c]) do
    Map.put(state, c,
      if get(state, a) == get(state, b) do
        1
      else
        0
      end
    )
  end

  def format_samples(str) do
    [before, command, result] =
      str
      |> extract_numbers
      |> Enum.chunk_every(4)

    {to_state(before), command, to_state(result)}
  end

  def test_ops({before, [command|args], result}) do
    {
      command,
      Enum.map(@ops, fn(op) ->
        {op, apply(__MODULE__, op, [before, args]) == result}
      end)
    }
  end

  def load_input() do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      [samples, program] =
        file
        |> String.split("\n\n\n", trim: true)

      {
        samples
        |> String.split("\n\n")
        |> Enum.map(&format_samples/1),
        program
        |> String.split("\n", trim: true)
        |> Enum.map(fn(ops) ->
          ops
          |> String.split(" ")
          |> Enum.map(&String.to_integer/1)
        end)
      }
    end
  end

  @doc ~S"""
      iex> extract_numbers("Before: [0, 3, 2, 3]\n8 2 2 2\nAfter:  [0, 3, 2, 3]")
      [0, 3, 2, 3, 8, 2, 2, 2, 0, 3, 2, 3]
  """
  def extract_numbers(str) do
    ~r/\d+/
      |> Regex.scan(str)
      |> List.flatten
      |> Enum.map(&String.to_integer/1)
  end

  @doc """
  I started by looking for most common "yes", now I think I need to disqualify
  by "no".

  For each opcode, cross out every command that is a fail somewhere.

  Then, find the one command that is fully identified, and remove it as an
  option for all the other opcodes, repeat until each opcode is related to only
  one command.
  """
  def frequency_analysis(samples) do
    test_results =
      for {opcode, results} <- samples, {command, result} <- results do
        {opcode, command, result}
      end

    for opcode <- 0..15 do
      {
        opcode,
        @ops
        |> Enum.reject(fn(option) ->
          Enum.any?(test_results, & &1 == {opcode, option, false})
        end)
        |> Enum.filter(fn(option) ->
          Enum.any?(test_results, & &1 == {opcode, option, true})
        end)
      }
    end
    |> elimination_round
  end

  @doc """
  Take the item that's one item, delete from all the others, add it to final
  map, repeat.
  """
  def elimination_round(list, result \\ %{})
  def elimination_round([], result), do: result
  def elimination_round(list, result) do
    {opcode, [command]} = Enum.find(list, & Enum.count(elem(&1, 1)) == 1)

    elimination_round(
      list
      |> Enum.map(&delete_command(&1, command))
      |> Enum.reject(&Enum.empty?(elem(&1, 1))),
      Map.put(result, opcode, command)
    )
  end

  def delete_command({num, commands}, command) do
    {num, List.delete(commands, command)}
  end

  def execute([], state, _), do: state
  def execute([[opcode|args]|remainder], state, opcodes) do
    newstate = apply(__MODULE__, Map.get(opcodes, opcode), [state, args])
    execute(remainder, newstate, opcodes)
  end

  def p1 do
    {samples, _} = load_input()

    samples
    |> Enum.map(&test_ops/1)
    |> Enum.filter(fn({_, ops}) ->
      3 <=
        ops
        |> Enum.filter(fn({_, worked?}) -> worked? end)
        |> Enum.count
    end)
    |> Enum.count
  end

  def p2 do
    {samples, program} = load_input()

    opcodes =
      samples
      |> Enum.map(&test_ops/1)
      |> frequency_analysis

    program
    |> execute(%{}, opcodes)
    |> Map.get(0)
  end
end

