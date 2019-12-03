defmodule Advent2019.Day3 do
  @moduledoc "https://adventofcode.com/2019/day/3"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      [wire1, wire2] =
        file
        |> read_wires
        |> Enum.map(&follow_wire/1)

      intersections =
        wire1
        |> MapSet.new
        |> MapSet.intersection(MapSet.new(wire2))
        |> MapSet.delete({0, 0})

      %{wires: {wire1, wire2}, intersections: intersections}
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

  def p1(%{intersections: intersections}) do
    intersections
    |> Enum.min_by(fn({x, y}) -> abs(x) + abs(y) end)
    |> (fn({x, y}) -> abs(x) + abs(y) end).()
  end

  @doc """
  calculate the number of steps each wire takes to reach each intersection;
  choose the intersection where the sum of both wires' steps is lowest. If a
  wire visits a position on the grid multiple times, use the steps value from
  the first time it visits that position when calculating the total value of a
  specific intersection.
  """
  def p2(%{wires: {wire1, wire2}, intersections: intersections}) do
    intersections
    |> Enum.map(fn(coord) ->
      {
        Enum.find_index(Enum.reverse(wire1), & coord == &1) +
        Enum.find_index(Enum.reverse(wire2), & coord == &1),
        coord
      }
    end)
    |> Enum.map(fn({combined_distance, _}) -> combined_distance end)
    |> Enum.min
  end
end
