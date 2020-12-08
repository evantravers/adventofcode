defmodule Advent2020.Day8 do
  @moduledoc "https://adventofcode.com/2020/day/8"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, &parse_instruction/2)
      |> Map.update!(:instructions, &Enum.reverse(&1))
      |> Map.put(:pointer, 0)
      |> Map.put(:accumulator, 0)
    end
  end

  @spec parse_instruction(String.t, Map) :: Map
  def parse_instruction(string, state) do
    [code, arg] = String.split(string, " ")

    instruction = {String.to_atom(code), String.to_integer(arg)}

    Map.update(state, :instructions, [instruction], & [instruction|&1])
  end

  def p1(state) do
    state
  end
  def p2(_i), do: nil
end
