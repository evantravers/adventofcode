defmodule Advent2019.Day4 do
  @moduledoc "https://adventofcode.com/2019/day/4"
  @behaviour Advent

  def setup do
    387638..919123
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
