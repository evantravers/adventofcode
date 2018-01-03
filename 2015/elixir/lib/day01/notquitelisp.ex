defmodule Advent2015.Day1 do
  @moduledoc """
  An opening parenthesis, (, means he should go up one floor, and a closing
  parenthesis, ), means he should go down one floor.
  """

  def parse(string, floors \\ [0])
  def parse([], floors), do: Enum.reverse(floors)
  def parse([char|input], floors) do
    current_floor = hd floors
    case char do
      "(" -> parse(input, [current_floor + 1|floors])
      ")" -> parse(input, [current_floor - 1|floors])
    end
  end

  def last_floor(floor_history) do
    floor_history
    |> List.last
  end

  @doc ~S"""
      iex> "()())"
      ...> |> String.graphemes
      ...> |> Advent2015.Day1.parse
      ...> |> Advent2015.Day1.find_basement
      5
  """
  def find_basement(floor_history) do
    floor_history
    |> Enum.find_index(fn floor -> floor == -1 end)
  end

  def load_file do
    {:ok, file} = File.read("#{__DIR__}/input.txt")

    file
    |> String.graphemes
  end

  def p1 do
    load_file()
    |> parse
    |> last_floor
  end

  def p2 do
    load_file()
    |> parse
    |> find_basement
  end
end
