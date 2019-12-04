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
  - It is a six-digit number.
  - The value is within the range given in your puzzle input.
  - Two adjacent digits are the same (like 22 in 122345).
  - Going from left to right, the digits never decrease; they only ever
    increase or stay the same (like 111123 or 135679).

      iex> validate_password(111111)
      true

      iex> validate_password(223450)
      false

      iex> validate_password(123789)
      false
  """
  def validate_password(number) do
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
         true <- has_double(list_of_integers)
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
  def p1(input) do

  end

  def p2(input) do

  end
end
