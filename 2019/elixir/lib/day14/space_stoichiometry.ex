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

  Psuedo:

  > In order to get FUEL, I need 2x X and 3x Y.
  >   In orer to get 2x X, I need...
  >   In orer to get 3x Y, I need...
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

  FIXME: do the math. This solution doesn't take into account the fact that
  each recipe makes multiples of an element.
  """
  def compute_cost(graph) do
    :FUEL
    |> compute_cost(graph, 1)
    |> List.flatten
    |> Enum.sum
  end

  def compute_cost(:ORE, _graph, mul), do: mul
  def compute_cost(element, graph, mul) do
    %{ingredients: ingredients, result: result} = Map.get(graph, element)

    Enum.map(ingredients, fn({required_num, required_element}) ->
      x = Integer.floor_div(required_num, result)
      compute_cost(required_element, graph, mul * x)
    end)
  end

  @doc """
  Compute ORE cost to make 1 FUEL.

  Starting from FUEL, recursively search backwards to determine the total cost
  in ORE.
      iex> "1 ORE => 1 FUEL"
      ...> |> setup_from_string
      ...> |> p1
      1

      iex> "2 A => 1 FUEL
      ...> 2 ORE => 1 A"
      ...> |> setup_from_string
      ...> |> p1
      4

      iex> "2 A => 1 FUEL
      ...> 2 ORE => 2 A"
      ...> |> setup_from_string
      ...> |> p1
      2

      iex> "2 A => 1 FUEL
      ...> 2 ORE => 5 A"
      ...> |> setup_from_string
      ...> |> p1
      2

      iex> "10 ORE => 10 A
      ...> 1 ORE => 1 B
      ...> 7 A, 1 B => 1 C
      ...> 7 A, 1 C => 1 D
      ...> 7 A, 1 D => 1 E
      ...> 7 A, 1 E => 1 FUEL"
      ...> |> setup_from_string
      ...> |> p1
      31

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
  def p1(graph), do: compute_cost(graph)

  def p2(_input), do: nil
end
