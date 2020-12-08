defmodule Advent2020.Day8 do
  @moduledoc "https://adventofcode.com/2020/day/8"

  def setup do
    with {:ok, str} <- File.read("#{__DIR__}/input.txt"), do: build_state(str)
  end

  def build_state(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &parse_instruction/2)
    |> Map.update!(:instructions, fn(instructions) ->
      instructions
      |> Enum.reverse
      |> Enum.with_index
      |> Enum.map(fn({v, k}) -> {k, v} end)
      |> Map.new
    end)
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

  def execute(state = %{
                        pointer: pointer,
                        instructions: instructions,
                        visited: visited
                      }) do
    cond do
      pointer == Enum.count(instructions) -> {:ok, state}
      Enum.member?(visited, pointer)  -> {:infinite, state}
      true ->
        instructions
        |> Map.get(pointer)
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

  def flip(:nop), do: :jmp
  def flip(:jmp), do: :nop

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
    with {:infinite, final} <- execute(state) do
      Map.get(final, :accumulator)
    end
  end
  def p2(starting_state) do
    starting_state
    |> Map.get(:instructions)
    |> Enum.filter(fn({_index, {code, _arg}}) -> code == :jmp || code == :nop end)
    |> Enum.find_value(fn({index, {op, arg}}) ->
      flipped = put_in(starting_state, [:instructions, index], {flip(op), arg})

      with {:ok, final} <- execute(flipped) do
        final
      else
        {:infinite, _state} -> false
      end
    end)
    |> Map.get(:accumulator)
  end
end
