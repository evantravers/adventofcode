defmodule Advent2023.Day4 do
  @moduledoc "https://adventofcode.com/2023/day/4"

  def setup do
    with {:ok, file} <- File.read("../input/4") do
      setup_from_string(file)
    end
  end

  def setup_from_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&build_card/1)
  end

  def nums(str) do
    str
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> MapSet.new
  end

  @doc """
  iex> "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
  ...> |> build_card
  {1, %{have: MapSet.new([83, 86, 6, 31, 17, 9, 48, 53]), winners: MapSet.new([41, 48, 83, 86, 17]) }}
  """
  def build_card(str) do
    [_match, id]    = Regex.run(~r/(?:^Card +)(\d+)/, str)
    [_id, numbers]  = String.split(str, ":")
    [winners, have] = String.split(numbers, "|")

    {String.to_integer(id), %{winners: nums(winners), have: nums(have)}}
  end

  def weird_scoring(0), do: 0 # empty case
  def weird_scoring(num, final \\ 1)
  def weird_scoring(1, final), do: final
  def weird_scoring(num, final), do: weird_scoring(num-1, final*2)

  def number_of_winners({_id, %{winners: winners, have: have}}) do
    winners
    |> MapSet.intersection(have)
    |> Enum.count
  end

  def update_multipliers(multipliers, card) do
    winners = number_of_winners(card)
    {id, _attr} = card
    copies = Map.get(multipliers, id, 1)

    if winners > 0 do
      id+1..id+winners
      |> Enum.reduce(multipliers, fn(id, multipliers) ->
        Map.update(multipliers, id, 2, & &1+copies)
      end)
    else
      multipliers
    end
  end

  def play(cards, multipliers \\ %{}, score \\ 0)
  def play([], _multipliers, score), do: score
  def play([card|cards], multipliers, score) do
    {id, _attr} = card

    play(
      cards,
      update_multipliers(multipliers, card),
      score + (Map.get(multipliers, id, 1))
    )
  end

  @doc """
  iex> "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  ...>Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  ...>Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  ...>Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  ...>Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  ...>Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
  ...>|> setup_from_string
  ...>|> p1
  13
  """
  def p1(cards) do
    cards
    |> Enum.map(fn card ->
      card
      |> number_of_winners
      |> weird_scoring
    end)
    |> Enum.sum
  end

  @doc """
  iex> "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
  ...>Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
  ...>Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
  ...>Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
  ...>Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
  ...>Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11"
  ...>|> setup_from_string
  ...>|> p2
  30
  """
  def p2(cards), do: play(cards)
end
