defmodule Advent2018.Day11 do
  @moduledoc "https://adventofcode.com/2018/day/11"

  @input 1309

  @doc """
  The power level in a given fuel cell can be found through the following process:

  - Find the fuel cell's rack ID, which is its X coordinate plus 10.
  - Begin with a power level of the rack ID times the Y coordinate.
  - Increase the power level by the value of the grid serial number (your
    puzzle input).
  - Set the power level to itself multiplied by the rack ID.
  - Keep only the hundreds digit of the power level (so 12345 becomes 3;
    numbers with no hundreds digit become 0).
  - Subtract 5 from the power level.

      iex> powerlevel({3, 5}, 8)
      4
  """
  def powerlevel({x, y}, input \\ @input) do
    rack_id = x + 10

    rack_id
    |> Kernel.*(y)
    |> Kernel.+(input)
    |> Kernel.*(rack_id)
    |> get_digit_in_hundredths
    |> Kernel.-(5)
  end

  @doc ~S"""
      iex> get_digit_in_hundredths(12345)
      3
  """
  def get_digit_in_hundredths(num) do
    num
    |> Integer.to_charlist
    |> Enum.at(-3)
    |> List.wrap
    |> List.to_string
    |> String.to_integer
  end

  def p1, do: nil
  def p2, do: nil
end
