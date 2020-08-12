defmodule Advent2019.Day14 do
  @moduledoc """
  https://adventofcode.com/2019/day/14

  I'm still reading the instructions, but I'm kind of feeling that this a
  weighted graph problem?

  It's basically a factorio problem, hah!
  """

  def setup do
    with {:ok, string} <- File.read("#{__DIR__}/input.txt") do
      string
      |> String.split("\n", trim: true)
      |> Enum.map(&string_to_reaction/1)
    end
  end

  def string_to_reaction(str) do
    str
    |> String.split(" => ", trim: true)
    |> Enum.map(&process_ingredients/1)
  end

  def process_ingredients(str) do
    str
    |> String.split(", ", trim: true)
    |> Enum.map(fn(s) ->
      s
      |> String.split(" ", trim: true)
      |> (fn([amount, ingredient]) ->
        [String.to_integer(amount), ingredient]
      end).()
    end)
  end

  def p1(input) do
    input
  end
  def p2(input), do: nil
end
