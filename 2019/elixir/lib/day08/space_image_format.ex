defmodule Advent2019.Day8 do
  @moduledoc "https://adventofcode.com/2019/day/8"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.graphemes
      |> Enum.reject(& &1 == "\n")
      |> Enum.map(&String.to_integer/1)
    end
  end

  def p1(list_of_integers) do
    least_zeroes =
      list_of_integers
      |> Enum.chunk_every(25*6)
      |> Enum.min_by(fn(layer) ->
        layer
        |> Enum.filter(& &1 == 0)
      end)

    ones =
      least_zeroes
      |> Enum.filter(& &1 == 1)
      |> Enum.count

    twos =
      least_zeroes
      |> Enum.filter(& &1 == 2)
      |> Enum.count

    ones * twos
  end

  def p2(i) do
  end
end
