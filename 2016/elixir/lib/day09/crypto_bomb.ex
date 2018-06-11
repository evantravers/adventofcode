defmodule Advent2016.Day9 do
  @moduledoc """
  http://adventofcode.com/2016/day/9

  The format compresses a sequence of characters. Whitespace is ignored. To
  indicate that some sequence should be repeated, a marker is added to the
  file, like (10x2). To decompress this marker, take the subsequent 10
  characters and repeat them 2 times. Then, continue reading the file after
  the repeated data. The marker itself is not included in the decompressed
  output.

  If parentheses or other characters appear within the data referenced by a
  marker, that's okay - treat it like normal data, not a marker, and then
  resume looking for markers after the decompressed section.
  """

  @doc ~S"""
      iex> decompress("(3x3)XYZ")
      9

      iex> decompress("X(8x2)(3x3)ABCY")
      20

      iex> decompress("(27x12)(20x12)(13x14)(7x10)(1x12)A")
      241920

      iex> decompress("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
      445
  """
  def decompress(string) do
    string |> String.graphemes |> count
  end

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input") do
      file
      |> String.replace(~r/\s/, "")
    end
  end

  def decrement_multipliers(state) do
    state
    |> Map.update(:mul, [], fn(list_of_multipliers) ->
      list_of_multipliers
      |> Enum.reject(fn({l, _}) -> l == 0 end)
      |> Enum.map(fn({length, mul}) ->
        {length - 1, mul}
      end)
    end)
  end

  def multiplier(state) do
    state
    |> Map.get(:mul)
    |> Enum.map(fn({_, mul}) -> mul end)
    |> Enum.reduce(1, fn(num, acc) -> num * acc end)
  end

  def increase_score(state) do
    state |> Map.update(:score, 0, & &1 + multiplier(state))
  end

  def marker(state = %{chars: [char|chars]}, length \\ nil, acc \\ "") do
    case char do
      "x" ->
        state
        |> decrement_multipliers
        |> Map.put(:chars, chars)
        |> marker(String.to_integer(acc), "")
      ")" ->
        state
        |> decrement_multipliers
        |> Map.put(:chars, chars)
        |> Map.update(:mul, [], fn(mul) ->
          [{length, String.to_integer(acc)}|mul]
        end)
        |> count
      _   ->
        state
        |> decrement_multipliers
        |> Map.put(:chars, chars)
        |> marker(length, acc <> char)
    end
  end

  @doc """
  # Model:
  - chars: current characters to iterate through
  - score: final score for the end of p2
  - mul: currently active multipliers
  """
  def count(list_of_characters) when is_list(list_of_characters) do
    count(%{chars: list_of_characters, score: 0, mul: []})
  end

  def count(state = %{chars: []}), do: state.score
  def count(state = %{chars: [char|chars]}) do
    case char do
      "(" ->
        state
        |> decrement_multipliers
        |> Map.put(:chars, chars)
        |> marker
      _ ->
        state
        |> decrement_multipliers
        |> increase_score
        |> Map.put(:chars, chars) # essentially continue the reduce
        |> count
    end
  end

  def p1, do: nil
  def p2 do
    load_input()
    |> decompress
  end
end
