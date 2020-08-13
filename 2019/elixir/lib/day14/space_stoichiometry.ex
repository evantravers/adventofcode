defmodule Advent2019.Day14 do
  @moduledoc """
  https://adventofcode.com/2019/day/14

  I'm still reading the instructions, but I'm kind of feeling that this a
  weighted graph problem? Yes, it's a dependency graph.

  It's basically a factorio problem, hah!

  Current strategy:

  1. Encode each recipe as a structured Map
  2. Work backwards from FUEL to ORE, following and reducing through the
     "graph".

  """

  @doc """
  Takes the input string and builds a map of reaction recipes.
  """
  def setup do
    with {:ok, string} <- File.read("#{__DIR__}/input.txt") do
      setup_from_string(string)
    end
  end

  def setup_from_string(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, &process_reaction/2)
  end


  @doc """
      iex> process_reaction("9 ORE => 2 A")
      %{A: %{result: 2, ingredients: [{9, :ORE}]}}

      iex> process_reaction("9 ORE, 5 C => 2 A")
      %{A: %{result: 2, ingredients: [{9, :ORE}, {5, :C}]}}
  """
  def process_reaction(str, map \\ %{}) do
    [input_str, output_str] = String.split(str, " => ")

    {o_count, o} = string_to_ingredient(output_str)

    ingredients =
      input_str
      |> String.split(", ", trim: true)
      |> Enum.map(&string_to_ingredient/1)

    Map.put(map, o, %{result: o_count, ingredients: ingredients})
  end

  @doc """
      iex> string_to_ingredient("9 ORE")
      {9, :ORE}
  """
  def string_to_ingredient(str) do
    [count, type] = String.split(str, " ", trim: true)
    {String.to_integer(count), String.to_atom(type)}
  end

  @doc """
  Compute cost of a system from FUEL -> ORE.
  """
  def compute_cost(graph, node, score \\ %{total: 1, mul: 1}) do
    reaction = Map.get(graph, node)

    next_paths =
      reaction
      |> Map.get(:ingredients)
      |> Enum.map(&elem(&, 1))

    total
  end

  @doc """
  Compute ORE cost to make 1 FUEL.

  Starting from FUEL, recursively search backwards to determine the total cost
  in ORE.

      iex> "9 ORE => 2 A
      ...> 8 ORE => 3 B
      ...> 7 ORE => 5 C
      ...> 3 A, 4 B => 1 AB
      ...> 5 B, 7 C => 1 BC
      ...> 4 C, 1 A => 1 CA
      ...> 2 AB, 3 BC, 4 CA => 1 FUEL"
      ...> |> setup_from_string
      ...> |> p1
      165
  """
  def p1(graph) do
    compute_cost(graph, :FUEL)
  end

  def p2(_input), do: nil
end
