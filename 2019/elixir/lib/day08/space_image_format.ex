defmodule Advent2019.Day8 do
  @moduledoc "https://adventofcode.com/2019/day/8"
  @behaviour Advent

  @width  25
  @height 6

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
      |> Enum.chunk_every(@width*@height)
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

  def pixel(0), do: " "
  def pixel(1), do: "█"

  def p2(list_of_integers) do
    list_of_integers
    |> Enum.chunk_every(@width*@height)
    |> Enum.zip
    |> Enum.map(fn(pixel_stack) ->
      pixel_stack
      |> Tuple.to_list
      |> Enum.reject(fn(pixel) -> pixel == 2 end)
      |> hd
      |> pixel
    end)
    |> Enum.chunk_every(@width)
    |> Enum.map(&Enum.join(&1))
    |> Enum.reduce("", fn(string, acc) -> "#{acc}\n#{string}" end)
  end
end
