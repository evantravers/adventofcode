defmodule Advent2019.Day3 do
  @moduledoc "https://adventofcode.com/2019/day/3"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> read_wires
    end
  end

  @doc """
  Takes in an input string of two wires and outputs:
  [
    [{:R, 2}, {:U, 4}],
    [{:D, 1}, {:L, 2}]
  ]

  I think in elixir terms, that's basically two keyword lists.
  """
  def read_wires(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&convert_to_instructions/1)
  end

  def convert_to_instructions(wire_string) do
    wire_string
    |> String.split(",", trim: true)
    |> Enum.map(&make_instruction/1)
  end

  def make_instruction(instruction_string) do
    { instruction, distance } = String.split_at(instruction_string, 1)

    { String.to_atom(instruction), String.to_integer(distance) }
  end

  def next_coord([{x, y}|_], :U), do: {x, y + 1}
  def next_coord([{x, y}|_], :D), do: {x, y - 1}
  def next_coord([{x, y}|_], :L), do: {x - 1, y}
  def next_coord([{x, y}|_], :R), do: {x + 1, y}

  def follow_wire(wire), do: follow_wire(wire, [{0, 0}])
  def follow_wire([], history), do: history
  def follow_wire([{_, 0}|tail], history), do: follow_wire(tail, history)
  def follow_wire([{dir, distance}|tail], history) do
    follow_wire([{dir, distance - 1}|tail], [next_coord(history, dir)|history])
  end

  @doc ~S"""
      iex> "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83"
      iex> |> read_wires
      iex> |> p1
      159
  """
  def p1(wires) do
    [wire1, wire2] =
      wires
      |> Enum.map(&follow_wire/1)

    wire1
    |> MapSet.new
    |> MapSet.intersection(MapSet.new(wire2))
    |> MapSet.delete({0, 0})
    |> Enum.min_by(fn({x, y}) -> {abs(x), abs(y)} end)
    |> (fn({x, y}) -> x + y end).()
  end

  def p2(input) do

  end
end
