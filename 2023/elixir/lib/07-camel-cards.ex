defmodule Advent2023.Day7 do
  @moduledoc "https://adventofcode.com/2023/day/7"

  defmodule Hand do
    defstruct cards: nil, class: nil

    def new(string) when is_binary(string) do
      cards =
        string
        |> String.codepoints
        |> Enum.map(&value/1)
      %Hand{
        cards: cards,
        class: classify(cards)
      }
    end

    def value("A"), do: 14
    def value("K"), do: 13
    def value("Q"), do: 12
    def value("J"), do: 11
    def value("T"), do: 10
    def value(num), do: String.to_integer(num)

    def classify([{_card, 5}]), do:                                       7 # five of a kind
    def classify([{_c1, 4}, {_c2, 1}]), do:                               6 # four of a kind
    def classify([{_c1, 3}, {_c2, 2}]), do:                               5 # full house
    def classify([{_c1, 3}, {_c2, 1}, {_c3, 1}]), do:                     4 # three of a kind
    def classify([{_c1, 2}, {_c2, 2}, {_c3, 1}]), do:                     3 # two pair
    def classify([{_c1, 2}, {_c2, 1}, {_c3, 1}, {_c4, 1}]), do:           2 # one pair
    def classify([{_c1, 1}, {_c2, 1}, {_c3, 1}, {_c4, 1}, {_c5, 1}]), do: 1 # high card
    def classify(cards) do
      cards
      |> Enum.frequencies
      |> Map.to_list
      |> List.keysort(1)
      |> Enum.reverse
      |> classify
    end

    def first_card([c1|cards1], [c2|cards2]) when c1 == c2, do: first_card(cards1, cards2)
    def first_card([c1|_cards1], [c2|_cards2]) do
      if c1 > c2 do
        :gt
      else
        :lt
      end
    end

    def compare(h1, h2) when h1 == h2, do: :eq
    def compare(
      %Hand{cards: cards1} = c1,
      %Hand{cards: cards2} = c2)
      when c1.class == c2.class do
      first_card(cards1, cards2)
    end
    def compare(h1, h2) when h1.class > h2.class, do: :gt
    def compare(h1, h2) when h1.class < h2.class, do: :lt
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

      {
        Hand.new(cards),
        String.to_integer(bid)
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
    |> Enum.sort_by(fn {hand, _bid} -> hand end, Hand)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_hand, bid}, rank} -> bid * rank end)
    |> Enum.sum
  end
  def p2(_i), do: nil
end
