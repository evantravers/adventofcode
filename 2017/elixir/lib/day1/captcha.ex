defmodule Advent2017.Day1 do
  @moduledoc """
  The captcha requires you to review a sequence of digits (your puzzle input)
  and find the sum of all digits that match the next digit in the list. The
  list is circular, so the digit after the last digit is the first digit in the
  list.

  For example:

  - 1122 produces a sum of 3 (1 + 2) because the first digit (1) matches the
  second digit and the third digit (2) matches the fourth digit.

  - 1111 produces 4 because each digit (all 1) matches the next.

  - 1234 produces 0 because no digit matches the next.

  - 91212129 produces 9 because the only digit that matches the next one is the
  last digit, 9.

  What is the solution to your captcha?
  """
  def captcha(array_of_numbers, calc_index) do
    size = Enum.count(array_of_numbers)

    array_of_numbers
    |> Enum.with_index
    |> Enum.reduce(0, fn ({num, index}, acc) ->

      next_index = calc_index.(index, size)
      next       = Enum.at(array_of_numbers, next_index)

      case num == next do
        true  -> acc + num
        false -> acc
      end
    end)
  end

  def numbers do
    {:ok, file} = File.open "./lib/day1/input.txt"

    # it'd be much better to read in by character, but hey
    file
    |> IO.read(:all)
    |> String.trim
    |> String.split("", trim: true)
    |> Enum.map(fn(x) -> String.to_integer(x) end)
  end

  def p1 do
    captcha(numbers(), fn (index, size) ->
      rem(index + 1, size)
    end)
  end
  def p2 do
    captcha(numbers(), fn (index, size) ->
      rem(index + (div(size, 2)), size)
    end)
  end
end
