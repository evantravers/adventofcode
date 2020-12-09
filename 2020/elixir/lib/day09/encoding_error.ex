defmodule Advent2020.Day9 do
  @moduledoc "https://adventofcode.com/2020/day/9"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end
  end

  def valid?(twentysix) do
    [sum|twentyfive] = Enum.reverse(twentysix)

    Enum.any?(twentyfive, fn(int1) ->
      Enum.any?(List.delete(twentyfive, int1), fn(int2) ->
        sum == int1 + int2
      end)
    end)
  end

  def invalid?(list), do: !valid?(list)

  def find_contiguous(integers, target, visited \\ [])
  def find_contiguous([consider|remaining] = entire, target, visited) do
    cond do
      Enum.sum(visited) + consider == target -> [consider|visited] # win
      Enum.sum(visited) + consider > target -> # try again with remaining.
        find_contiguous(tl(Enum.reverse(visited) ++ entire), target)
      Enum.sum(visited) + consider < target ->
        find_contiguous(remaining, target, [consider|visited]) # hit the dealer
    end
  end

  def p1(integers) do
    integers
    |> Enum.chunk_every(26, 1)
    |> Enum.find(&invalid?/1)
    |> List.last
  end

  @doc """
      iex> [35, 20, 15, 25, 47, 40, 62, 55, 65, 95, 102, 117, 150, 182, 127, 219, 299, 277, 309, 576]
      ...> |> p2(127)
      62
  """
  def p2(integers, target \\ 258585477) do
    integers
    |> find_contiguous(target)
    |> Enum.min_max
    |> Tuple.to_list
    |> Enum.sum
  end
end
