defmodule Advent2019.Day3 do
  @moduledoc "https://adventofcode.com/2019/day/3"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> read_wires
    end
  end

  defp read_wires(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&convert_to_instructions/1)
  end

  defp convert_to_instructions(wire_string) do
    wire_string
    |> String.split(",", trim: true)
    |> Enum.map(&make_instruction/1)
  end

  defp make_instruction(instruction_string) do
    { instruction, distance } = String.split_at(instruction_string, 1)

    { String.to_atom(instruction), String.to_integer(distance) }
  end

  def p1([wire1, wire2]) do
  end

  def p2(input) do

  end
end
