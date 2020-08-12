defmodule Advent2019.Day14 do
  @moduledoc """
  https://adventofcode.com/2019/day/14

  I'm still reading the instructions, but I'm kind of feeling that this a
  weighted graph problem? Yes, it's a dependency graph.

  It's basically a factorio problem, hah!
  """

  def setup do
    with {:ok, string} <- File.read("#{__DIR__}/input.txt") do
      setup_map(string)
    end
  end

  def setup_map(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&string_to_reaction/1)
  end

  def string_to_reaction(str) do
    str
    |> String.split(" => ", trim: true)
    |> Enum.map(&process_ingredients/1)
  end

  def process_ingredients(str) do
    str
    |> String.split(", ", trim: true)
    |> Enum.map(fn(s) ->
      s
      |> String.split(" ", trim: true)
      |> (fn([amount, ingredient]) ->
        [String.to_integer(amount), String.to_atom(ingredient)]
      end).()
    end)
  end

  @doc """
      iex> "9 ORE => 2 A
      ...> 8 ORE => 3 B
      ...> 7 ORE => 5 C
      ...> 3 A, 4 B => 1 AB
      ...> 5 B, 7 C => 1 BC
      ...> 4 C, 1 A => 1 CA
      ...> 2 AB, 3 BC, 4 CA => 1 FUEL"
      ...> |> setup_map
      ...> |> p1
      165
  """
  def p1(input) do
    input
  end
  def p2(input), do: nil
end
