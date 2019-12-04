defmodule Advent2019.Day4 do
  @moduledoc "https://adventofcode.com/2019/day/4"
  @behaviour Advent

  def setup do
    387638..919123
  end

  @doc """
      iex> has_double([1, 1, 1, 1, 1, 1])
      true

      iex> has_double([1, 2, 3, 4, 5, 6])
      false

      iex> has_double([1, 2, 3, 3, 5, 6])
      true
  """
  def has_double([a, b, c, d, e, f]) do
    a == b || b == c || c == d || d == e || e == f
  end

  @doc """
      iex> no_triplets([1, 1, 1, 1, 1, 1])
      false

      iex> no_triplets([1, 2, 3, 4, 5, 6])
      false

      iex> no_triplets([1, 2, 3, 3, 5, 6])
      true
  """
  def no_triplets([a, b, c, d, e, f]) do
    a == b && !Enum.any?([c, d, e, f], & &1 == a) ||
    b == c && !Enum.any?([a, d, e, f], & &1 == b) ||
    c == d && !Enum.any?([a, b, e, f], & &1 == c) ||
    d == e && !Enum.any?([a, b, c, f], & &1 == d) ||
    e == f && !Enum.any?([a, b, c, d], & &1 == e)
  end

  @doc """
  - It is a six-digit number.
  - The value is within the range given in your puzzle input.
  - Two adjacent digits are the same (like 22 in 122345).
  - Going from left to right, the digits never decrease; they only ever
    increase or stay the same (like 111123 or 135679).

      iex> valid_password?(111111, &has_double/1)
      true

      iex> valid_password?(223450, &has_double/1)
      false

      iex> valid_password?(123789, &has_double/1)
      false
  """
  def valid_password?(number, func) do
    [a, b, c, d, e, f] = list_of_integers =
      for div <- [1, 10, 100, 1_000, 10_000, 100_000] do
        number
        |> Integer.floor_div(div)
        |> Integer.mod(10)
      end
      |> Enum.reverse

    with true <- a <= b,
         true <- b <= c,
         true <- c <= d,
         true <- d <= e,
         true <- e <= f,
         true <- func.(list_of_integers)
    do
      true
    else
      false -> false
    end
  end

  @doc """
  How many different passwords within the range given in your puzzle input meet
  these criteria?
  """
  def p1(range) do
    range
    |> Stream.filter(fn(num) -> valid_password?(num, &has_double/1) end)
    |> Enum.count
  end

  def p2(range) do
    range
    |> Stream.filter(fn(num) -> valid_password?(num, &no_triplets/1) end)
    |> Enum.count
  end
end
