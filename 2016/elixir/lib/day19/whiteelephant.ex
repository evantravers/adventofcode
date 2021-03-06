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

  @total_number_of_elves 3_005_290

  def setup_game(num) do
    Enum.into(Enum.reverse(1..num), Deque.new(num))
  end

  @doc ~S"""
      iex> setup_game(5) |> steal_from_left
      3
  """
  def steal_from_left(players) do
    if Enum.count(players) == 1 do
      Enum.at(players, 0)
    else
      {current, players} = Deque.pop(players)
      {_, players}       = Deque.pop(players) # steal!
      steal_from_left(Deque.appendleft(players, current))
    end
  end

  @doc ~S"""
      iex> setup_game(5) |> steal_across
      2
  """
  def steal_across(players) do
    if Enum.count(players) == 1 do
      Enum.at(players, 0)
    else
      {current, players} = Deque.pop(players)

      players =
        players
        |> Enum.to_list
        |> List.delete_at(div(Enum.count(players), 2))
        |> Enum.into(Deque.new())

      steal_across(Deque.appendleft(players, current))
    end
  end

  def p1 do
    @total_number_of_elves
    |> setup_game
    |> steal_from_left
  end

  def p2 do
    @total_number_of_elves
    |> setup_game
    |> steal_across
  end
end
