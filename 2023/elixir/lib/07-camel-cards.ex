defmodule Advent2023.Day7 do
  @moduledoc "https://adventofcode.com/2023/day/7"

  defmodule Hand do
    defstruct cards: nil, bid: nil

    def compare(h1, h2) do
      :gt
    end
  end

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

      %Hand{
        cards:
        cards
        |> String.codepoints
        |> Enum.map(&String.to_atom/1),
        bid: String.to_integer(bid)
      }
    end)
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
    |> Enum.sort(Hand)
    |> Enum.with_index
    |> Enum.map(fn {hand, rank} -> Map.get(hand, :bid) * rank end)
    |> Enum.sum
  end
  def p2(_i), do: nil
end
