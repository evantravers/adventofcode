defmodule Advent2023.Day7 do
  @moduledoc "https://adventofcode.com/2023/day/7"

  def setup do
    with {:ok, file} <- File.read("../input/7") do
      file |> setup_from_string
    end
  end
  def setup_from_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      [cards, bid] = String.split(str, " ")

      {
        cards
        |> String.codepoints
        |> Enum.map(&String.to_atom/1),
        String.to_integer(bid)
      }
    end)
  end

  def stronger?(h1, h2) do
    h1 # TODO: Fix
  end

  @doc """
  iex> "32T3K 765
  ...>T55J5 684
  ...>KK677 28
  ...>KTJJT 220
  ...>QQQJA 483"
  ...> |> setup_from_string
  ...> |> p1
  6440
  """
  def p1(hands) do
    hands
    |> Enum.sort_by(fn{hand, _bid} -> hand end, &stronger?/2)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_hand, bid}, rank} -> bid * rank end)
    |> Enum.sum
  end
  def p2(_i), do: nil
end
