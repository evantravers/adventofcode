defmodule Advent2020.Day8 do
  @moduledoc "https://adventofcode.com/2020/day/8"

  def setup do
    with {:ok, str} <- File.read("#{__DIR__}/input.txt"), do: build_state(str)
  end

  def build_state(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &parse_instruction/2)
    |> Map.update!(:instructions, &Enum.reverse(&1))
    |> Map.put(:pointer, 0)
    |> Map.put(:accumulator, 0)
    |> Map.put(:visited, MapSet.new)
  end

  @spec parse_instruction(String.t, Map) :: Map
  def parse_instruction(string, state) do
    [code, arg] = String.split(string, " ")

    instruction = {String.to_atom(code), String.to_integer(arg)}

    Map.update(state, :instructions, [instruction], & [instruction|&1])
  end

  def execute(state = %{pointer: pointer,
                        instructions: instructions,
                        visited: visited}) do
    if Enum.member?(visited, pointer) do
      state
    else
      instructions
      |> Enum.at(pointer)
      |> evaluate(state)
      |> Map.update!(:visited, &MapSet.put(&1, pointer))
      |> execute
    end
  end

  def evaluate({:jmp, arg}, state) do
    state
    |> Map.update!(:pointer, & &1 + arg)
  end
  def evaluate({:acc, arg}, state) do
    state
    |> Map.update!(:accumulator, & &1 + arg)
    |> Map.update!(:pointer, & &1 + 1)
  end
  def evaluate({:nop, _arg}, state) do
    state
    |> Map.update!(:pointer, & &1 + 1)
  end

  @doc """
      iex> "nop +0
      ...>acc +1
      ...>jmp +4
      ...>acc +3
      ...>jmp -3
      ...>acc -99
      ...>acc +1
      ...>jmp -4
      ...>acc +6"
      ...> |> build_state
      ...> |> p1
      5
  """
  def p1(state) do
    state
    |> execute
    |> Map.get(:accumulator)
  end
  def p2(_i), do: nil
end
