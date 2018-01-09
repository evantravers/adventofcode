defmodule Advent2016.Day19 do
  @moduledoc """
  P1:
  Each Elf brings a present. They all sit in a circle, numbered starting with
  position 1. Then, starting with the first Elf, they take turns stealing all
  the presents from the Elf to their left. An Elf with no presents is removed
  from the circle and does not take turns.

  So, with five Elves, the Elf that sits starting in position 3 gets all the
  presents.  With the number of Elves given in your puzzle input, which Elf
  gets all the presents?

  P2:
  Realizing the folly of their present-exchange rules, the Elves agree to
  instead steal presents from the Elf directly across the circle. If two Elves
  are across the circle, the one on the left (from the perspective of the
  stealer) is stolen from. The other rules remain unchanged: Elves with no
  presents are removed from the circle entirely, and the other elves move in
  slightly to keep the circle evenly spaced.

  So, with five Elves, the Elf that sits starting in position 2 gets all the
  presents.

  With the number of Elves given in your puzzle input, which Elf now gets all
  the presents?
  """

  @total_number_of_elves 3005290

  def setup_game(num) do
    Enum.to_list(1..num)
  end

  @doc ~S"""
      iex> setup_game(5) |> steal_from_left
      3
  """
  def steal_from_left(players) when length(players) == 1, do: hd(players)
  def steal_from_left([current|players]) do
    steal_from_left(tl(players) ++ [current])
  end

  @doc ~S"""
      iex> setup_game(5) |> steal_across
      2
  """
  def steal_across(players) when length(players) == 1, do: hd(players)
  def steal_across([current|players]) do
    steal_across(List.delete_at(players, div(length(players), 2) - 1) ++ [current])
  end

  def p1 do
    setup_game(@total_number_of_elves)
    |> steal_from_left
  end

  def p2, do: nil
end
