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
    |> Enum.reduce(%{}, &store_recipe/2)
  end


  @doc """
      iex> store_recipe("9 ORE => 2 A")
      %{A: %{result: 2, ingredients: [{9, :ORE}]}}

      iex> store_recipe("9 ORE, 5 C => 2 A")
      %{A: %{result: 2, ingredients: [{9, :ORE}, {5, :C}]}}
  """
  def store_recipe(str, map \\ %{}) do
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

  Totally read this solution idea on reddit...
  https://www.reddit.com/r/adventofcode/comments/eafj32/2019_day_14_solutions/fbdpa3j/

  It's transaction nature feels really suited to Elixir, so let's give it a
  whirl!

  I could add a flag for unlimited vs. limited ORE, because I'm pretty sure
  that's where p2 is going to go.
  """
  def compute_cost(recipes) do
    [{1, :FUEL}]
    |> chain_reaction(recipes)
    |> Map.get(:SCORE)
  end

  def get_ingredients(elem, recipes), do: get_in(recipes, [elem, :ingredients])

  @doc """
  Is everything ready for the reaction?
  """
  def all_ingredients?(element, recipes, inventory) do
    Enum.all?(get_ingredients(element, recipes), fn({quantity, ingredient}) ->
      Map.get(inventory, ingredient, 0) >= quantity
    end)
  end

  def use_up_ingredient({count, element}, inventory) do
    Map.update!(inventory, element, & &1 - count)
  end

  def store_result(inventory, element, quantity) do
    Map.update(inventory, element, quantity, & &1 + quantity)
  end

  @doc """
  Should decrement all the ingredients, increment the result.
  """
  def run_reaction(inventory, element, recipes) do
    reaction_result = get_in(recipes, [element, :result])

    element
    |> get_ingredients(recipes)
    |> Enum.reduce(inventory, &use_up_ingredient/2)
    |> store_result(element, reaction_result)
  end

  def chain_reaction(orders, recipes, inventory \\ %{})
  def chain_reaction([], _recipes, inventory), do: inventory
  def chain_reaction([{quantity, :ORE}|orders], recipes, inventory) do
    # There's always ORE in the banana stand.
    chain_reaction(
      orders,
      recipes,
      inventory
      |> Map.update(:ORE, quantity, & &1 + quantity)
      |> Map.update(:SCORE, quantity, & &1 + quantity)
    )
  end
  def chain_reaction([{_quantity, element}|orders] = queue, recipes, inventory) do
    if all_ingredients?(element, recipes, inventory) do
      # run the reaction
      chain_reaction(
        orders,
        recipes,
        inventory
        |> run_reaction(element, recipes)
      )
    else
        # go fish
        chain_reaction(
          get_ingredients(element, recipes) ++ queue,
          recipes,
          inventory
        )
    end
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

      iex> "7 A => 1 FUEL
      ...> 3 ORE => 4 A"
      ...> |> setup_from_string
      ...> |> p1
      6

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
  def p1(recipes), do: compute_cost(recipes)

  def p2(_input), do: nil
end
