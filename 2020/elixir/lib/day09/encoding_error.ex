defmodule Advent2020.Day9 do
  @moduledoc "https://adventofcode.com/2020/day/9"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end
  end

  def valid?(list) when length(list) < 25, do: true
  def valid?(twentysix) do
    [sum|twentyfive] = Enum.reverse(twentysix)

    Enum.any?(twentyfive, fn(int1) ->
      Enum.any?(List.delete(twentyfive, int1), fn(int2) ->
        sum == int1 + int2
      end)
    end)
  end

  def invalid?(list), do: !valid?(list)

  def p1(integers) do
    integers
    |> Enum.chunk_every(26, 1)
    |> Enum.find(&invalid?/1)
    |> List.last
  end
  def p2(_i), do: nil
end
