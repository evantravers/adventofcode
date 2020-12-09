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
      Enum.sum(visited) + consider == target -> entire # win
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

  def p2(integers) do
    target = 258585477

    contiguous = find_contiguous(integers, target)
                 |> IO.inspect

    hd(contiguous) + List.last(contiguous)
  end
end
