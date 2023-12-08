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

    defimpl Inspect, for: Hand do
      def strength(7), do: "5 of a Kind"
      def strength(6), do: "4 of a Kind"
      def strength(5), do: "Full House "
      def strength(4), do: "3 of a Kind"
      def strength(3), do: "Two Pair   "
      def strength(2), do: "One Pair   "
      def strength(1), do: "High Card  "

      def inspect(hand, _opts) do
        h  = "#{IO.ANSI.red()}#{strength(hand.class)}#{IO.ANSI.white()}"
        c = "#{Enum.map(hand.cards, &String.pad_leading(Integer.to_string(&1), 2)) |> Enum.join(" ")}"

        "%Hand{#{h}: #{c}}"
      end
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

  def joker_rules(class, number_of_jokers)
  def joker_rules(class, 0), do: class # no jokers
  def joker_rules(7, 5), do: 7 # already 5 of a kind!
  def joker_rules(6, 1), do: 7 # add to the four of a kind:     five of a kind
  def joker_rules(6, 4), do: 7 # match the fifth card:          five of a kind
  def joker_rules(5, 2), do: 7 # is a set, match the other set: five of a kind
  def joker_rules(5, 3), do: 7 # is a set, match the other set: five of a kind
  def joker_rules(4, 1), do: 6 # match one of the cards:        four of a kind
  def joker_rules(4, 3), do: 6 # match one of the cards:        four of a kind
  def joker_rules(3, 1), do: 5 # match the other for:           full house
  def joker_rules(3, 2), do: 6 # is a pair, match the other:    four of a kind
  def joker_rules(2, 1), do: 4 # match the pair:                three of a kind
  def joker_rules(2, 2), do: 4 # is the pair, match a random:   three of a kind
  def joker_rules(1, 1), do: 2 # match a high card:             one pair

  def devalue_jokers(cards, zipper \\ [])
  def devalue_jokers([], zipper), do: Enum.reverse(zipper)
  def devalue_jokers([11|cards], zipper), do: devalue_jokers(cards, [1|zipper]) # count joker as value 1
  def devalue_jokers([card|cards], zipper), do: devalue_jokers(cards, [card|zipper])

  def apply_jokers(%Hand{cards: cards, class: class}) do
    jokers = Enum.count(cards, & &1 == 11) # still stored as ten by input

    %Hand{
      cards: devalue_jokers(cards),
      class: joker_rules(class, jokers)
    }
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

  @doc """
  iex> "32T3K 765
  ...>T55J5 684
  ...>KK677 28
  ...>KTJJT 220
  ...>QQQJA 483"
  ...> |> setup_from_string
  ...> |> p2
  5905
  """
  def p2(hands) do
    hands
    |> Enum.map(fn {hand, bid} -> {apply_jokers(hand), bid} end)
    |> Enum.sort_by(fn {hand, _bid} -> hand end, Hand)
    |> Enum.with_index(1)
    |> Enum.map(fn {{_hand, bid}, rank} -> bid * rank end)
    |> Enum.sum
  end
end
