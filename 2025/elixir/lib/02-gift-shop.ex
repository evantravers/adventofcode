defmodule Advent2025.Day2 do
  @moduledoc """
  https://adventofcode.com/2025/day/2

  I think the approach here is going to be to build a sieve. Starting from min
  iterate up to max. If you find a repeat number, mark all the multiples up to
  max as also invalid.

  Then I can merely ask how which "fake IDs" are included in the ranges.
  """

  def setup do
    with {:ok, file} <- File.read("../input/02") do
      values =
        file
        |> String.split(",", trim: true)
        |> Enum.map(fn(str) ->
          [min, max] = String.split(str, ~r/-|\n/, trim: true)
          {String.to_integer(min), String.to_integer(max)}
        end)

      {min, max} =
        values
        |> Enum.map(&Tuple.to_list/1)
        |> List.flatten
        |> Enum.min_max()

      ranges = Enum.map(values, fn({min, max}) -> min..max end)

      fakeIDs = sieve(min, max)

      {ranges, fakeIDs}
    end
  end

  def sieve(min, max) do
    possibles = min..max

    Stream.reject(possibles, & Integer.is_even(&1))
  end

  def p1(i) do
    i
  end

  def p2(_i), do: nil
end
