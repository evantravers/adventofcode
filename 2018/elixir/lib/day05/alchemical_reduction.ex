defmodule Advent2018.Day5 do
  @moduledoc """
  https://adventofcode.com/2018/day/5

  The polymer is formed by smaller units which, when triggered, react with each
  other such that two adjacent units of the same type and opposite polarity are
  destroyed. Units' types are represented by letters; units' polarity is
  represented by capitalization. For instance, r and R are units with the same
  type but opposite polarity, whereas r and s are entirely different types and
  do not react.

  Trying to steal @ahgilbert's idea for using zippers...
  """

  @doc """
      iex> react("dabAcCaCBAcCcaDA") |> String.length
      10
  """
  def react(str) do
    str
    |> String.graphemes
    |> react([])
  end

  @doc """
      iex> reactable?("a", "A")
      true
      iex> reactable?("A", "a")
      true
      iex> reactable?("A", "A")
      false
      iex> reactable?("b", "A")
      false
  """
  def reactable?(_, []), do: false
  def reactable?(char, prev_char) do
    String.downcase(char) == String.downcase(prev_char) && char != prev_char
  end

  def react([], visited), do: Enum.reverse(visited) |> Enum.join
  def react([char|string], []), do: react(string, [char])
  def react([current_char|string], visited = [prev_char|prev_string]) do
    if reactable?(current_char, prev_char) do
      react(string, prev_string)
    else
      react(string, [current_char| visited])
    end
  end

  @doc """
      iex> strip_polymer("dabAcCaCBAcCcaDA", ?c)
      "dabAaBAaDA"
  """
  def strip_polymer(string, char), do: String.replace(string, ~r/#{[char]}/i, "")

  @doc """
      iex> find_trouble_polymer("dabAcCaCBAcCcaDA")
      4
  """
  def find_trouble_polymer(input) do
    ?a..?z
    |> Enum.map(fn(polymer_to_remove) ->
      {polymer_to_remove,
        input
        |> strip_polymer(polymer_to_remove)
        |> react
        |> String.length}
    end)
    |> Enum.min_by(fn({_, length}) -> length end)
    |> elem(1)
  end

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.trim
    end
  end

  def p1 do
    load_input()
    |> react
    |> String.length
  end

  def p2 do
    load_input()
    |> find_trouble_polymer
  end
end

