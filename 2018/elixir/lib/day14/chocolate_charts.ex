defmodule Advent2018.Day14 do
  @moduledoc """
  https://adventofcode.com/2018/day/14

  Only two recipes are on the board: the first recipe got a score of 3, the second, 7. Each of the two Elves has a current recipe: the first Elf starts with the first recipe, and the second Elf starts with the second recipe.

  To create new recipes, the two Elves combine their current recipes. This
  creates new recipes from the digits of the sum of the current recipes'
  scores. With the current recipes' scores of 3 and 7, their sum is 10, and so
  two new recipes would be created: the first with score 1 and the second with
  score 0. If the current recipes' scores were 2 and 3, the sum, 5, would only
  create one recipe (with a score of 5) with its single digit.

  The new recipes are added to the end of the scoreboard in the order they are
  created. So, after the first round, the scoreboard is 3, 7, 1, 0.

  After all new recipes are added to the scoreboard, each Elf picks a new
  current recipe. To do this, the Elf steps forward through the scoreboard a
  number of recipes equal to 1 plus the score of their current recipe. So,
  after the first round, the first Elf moves forward 1 + 3 = 4 times, while the
  second Elf moves forward 1 + 7 = 8 times. If they run out of recipes, they
  loop back around to the beginning. After the first round, both Elves happen
  to loop around until they land on the same recipe that they had in the
  beginning; in general, they will move to different recipes.
  """

  @input 793031

  def play(num), do: play({%{0 => 3, 1 => 7}, 0, 1}, num)
  def play(state, 0), do: state
  def play({recipes, first_index, second_index}, num) do
    # To create new recipes, the two Elves combine their current recipes. This
    # creates new recipes from the digits of the sum of the current recipes'
    # scores.
    first_value  = get(recipes, first_index)
    second_value = get(recipes, second_index)
    combined_recipe   = first_value + second_value

    # After all new recipes are added to the scoreboard, each Elf picks a new
    # current recipe. To do this, the Elf steps forward through the scoreboard a
    # number of recipes equal to 1 plus the score of their current recipe.

    new_recipes = add(recipes, combined_recipe)

    new_first_index  = Integer.mod(first_index + 1 + first_value, Enum.count(new_recipes))
    new_second_index = Integer.mod(second_index + 1 + second_value, Enum.count(new_recipes))

    play({add(recipes, combined_recipe), new_first_index, new_second_index}, num - 1)
  end

  @doc """
  If the Elves think their skill will improve after making 9 recipes, the
  scores of the ten recipes after the first nine on the scoreboard would be
  5158916779 (highlighted in the last line of the diagram).
  After 5 recipes, the scores of the next ten would be 0124515891.
  After 18 recipes, the scores of the next ten would be 9251071085.
  After 2018 recipes, the scores of the next ten would be 5941429882.

      iex> next_ten(5)
      "0124515891"
      iex> next_ten(18)
      "9251071085"
      iex> next_ten(2018)
      "5941429882"
  """
  def next_ten(num) do
    num
    |> Kernel.+(10)
    |> play
    |> print
    |> String.graphemes
    |> Enum.slice(num..num+9)
    |> Enum.join
  end

  def get(map, index) do
    Map.get(map, at(map, index))
  end

  def at(map, index), do: Integer.mod(index, Enum.count(map))

  def add(map, num) do
    number =
      num
      |> Integer.to_string
      |> String.graphemes
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index(Enum.count(map))

    number
    |> Enum.map(fn({val, ind}) -> {ind, val} end)
    |> Enum.into(map)
  end

  def display({map, first, second}) do
    {
      map
      |> Map.update!(at(map, first), & "(#{&1})")
      |> Map.update!(at(map, second), & "[#{&1}]"),
      first,
      second
    }
    |> print
  end

  def print({map, _, _}) do
    map
    |> Enum.to_list
    |> List.keysort(0)
    |> Enum.map(&elem(&1, 1))
    |> Enum.join
  end

  def p1 do
    next_ten(@input)
  end

  def p2, do: nil
end

