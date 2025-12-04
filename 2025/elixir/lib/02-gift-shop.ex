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
      ranges =
        file
        |> String.split(",", trim: true)
        |> Enum.map(fn(str) ->
          [min, max] = String.split(str, ~r/-|\n/, trim: true)
          {String.to_integer(min), String.to_integer(max)}
        end)

      ranges
    end
  end

  def generate_ids(min, max, count \\ 1) do
    min..max
    |> Enum.reduce_while([], fn candidate, fake ->
      fakeID = dupe(candidate, count)

      if fakeID >= max do
        {:halt, fake}
      else
        {:cont, [fakeID|fake]}
      end
    end)
  end

  def dupe(int_or_digits, count \\ 1)
  def dupe(digits, 0), do:     Integer.undigits(digits)
  def dupe(integer, count) when is_integer(integer) do
    dupe(Integer.digits(integer), count)
  end
  def dupe(digits, count) when is_list(digits) do
    dupe(digits ++ digits, count - 1)
  end

  def min_max(ranges) do
    ranges
    |> Enum.map(&Tuple.to_list/1)
    |> List.flatten
    |> Enum.min_max()
  end

  def count_occurences(fakeIDs, ranges) do
    fakeIDs
    |> Enum.reduce(0, fn (id, sum) ->
      sum + id * Enum.count(ranges, fn {min, max} ->
        id >= min && id <= max
      end)
    end)
  end

  def p1(ranges) do
    {min, max} = min_max(ranges)

    fakeIDs = generate_ids(min, max)

    count_occurences(fakeIDs, ranges)
  end

  def p2(ranges) do
    {min, max} = min_max(ranges)

    fakeIDs = for n <- 1..10, do: generate_ids(min, max, n)

    count_occurences(List.flatten(fakeIDs), ranges)
  end
end
