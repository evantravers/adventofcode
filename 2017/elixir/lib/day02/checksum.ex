defmodule Advent2017.Day2 do
  @moduledoc """
  P1: The spreadsheet consists of rows of apparently-random numbers. To make
  sure the recovery process is on the right track, they need you to calculate
  the spreadsheet's checksum. For each row, determine the difference between
  the largest value and the smallest value; the checksum is the sum of all of
  these differences.

  P2: It sounds like the goal is to find the only two numbers in each row where
  one evenly divides the other - that is, where the result of the division
  operation is a whole number. They would like you to find those numbers on
  each line, divide them, and add up each line's result.
  """

  def find_divisible ([current|tail]) do
    number = Enum.find(tail, fn (item) -> rem(current, item) == 0 end)
    case number do
      nil ->
        find_divisible tail
      _ ->
        {current, number}
    end
  end

  def file do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(
      fn (line) ->
        line
        |> String.split("\t")
        |> Enum.map(&(String.to_integer(&1)))
      end)
  end

  def p1 do
    file()
    |> Enum.reduce(0, fn(list, acc) ->
      diff = Enum.max(list) - Enum.min(list)
      acc + diff
    end)
  end

  def p2 do
    file()
    |> Enum.map(&Enum.sort/1)
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(&find_divisible/1)
    |> Enum.map(fn({a, b}) -> div(a, b) end)
    |> Enum.sum
  end
end
