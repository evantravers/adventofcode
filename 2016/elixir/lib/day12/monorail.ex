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
        |> clean
      end)
      |> Enum.with_index
      |> Enum.map(fn({v, i}) ->{i, v} end)
      |> Enum.into(%{})
    end
  end

  @doc """
      iex> clean(["cpy", "a", "7"])
      [:cpy, :a, 7]
  """
  def clean([cmd|args]) do
    [String.to_atom(cmd)|Enum.map(args, &clean_arg/1)]
  end

  def clean_arg("a"), do: :a
  def clean_arg("b"), do: :b
  def clean_arg("c"), do: :c
  def clean_arg("d"), do: :d
  def clean_arg(num), do: String.to_integer(num)

  def resolve(state, reg) when is_atom(reg),    do: Map.get(state, reg)
  def resolve(_,     num) when is_integer(num), do: num

  def next_instruction(state), do: Map.update!(state, :pointer, & &1 + 1)

  def run(state = %{instructions: instructions, pointer: pointer}) do
    with i=[cmd|args] when not is_nil(i) <- Map.get(instructions, pointer) do
      case cmd do
        :inc ->
          x = hd(args)
          state
          |> Map.update!(x, & &1 + 1)
          |> next_instruction
        :dec ->
          x = hd(args)
          state
          |> Map.update!(x, & &1 - 1)
          |> next_instruction
        :cpy ->
          [x, y] = args
          state
          |> Map.put(y, resolve(state, x))
          |> next_instruction
        :jnz ->
          [x, y] = args
          if Map.get(state, x) != 0 do
            state
            |> Map.update!(:pointer, & &1 + y)
          else
            state
            |> next_instruction
          end
      end
      |> run
    else
      _ -> state
    end
  end

  def start_state do
    %{a: 0, b: 0, c: 0, d: 0, pointer: 0}
    |> Map.put(:instructions, load_input())
  end

  def p1 do
    start_state()
    |> run
    |> Map.get(:a)
  end

  def p2 do
    start_state()
    |> Map.put(:c, 1)
    |> run
    |> Map.get(:a)
  end
end
