defmodule Advent2023.Day4 do
  @moduledoc "https://adventofcode.com/2023/day/4"

  def setup do
    with {:ok, file} <- File.read("../input/4") do
      file |> setup_from_string
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
  end

  @doc """
  iex> "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53"
  ...> |> build_card
  %{id: 1, have: [83, 86, 6, 31, 17, 9, 48, 53], winners: [41, 48, 83, 86, 17] }
  """
  def build_card(str) do
    [_match, id]    = Regex.run(~r/(?:^Card )(\d+)/, str)
    [_id, numbers]  = String.split(str, ":")
    [winners, have] = String.split(numbers, "|")

    %{id: String.to_integer(id), winners: nums(winners), have: nums(have)}
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
  """
  def p1(cards) do
    cards
    |> Enum.filter(fn card ->  end)
  end

  def p2(_i), do: nil
end
