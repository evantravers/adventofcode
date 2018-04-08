defmodule Advent2016.Day6 do
  @moduledoc """
  http://adventofcode.com/2016/day/6

  the codex's datastructure should be something like:
  %{0 => %{"a" => 2, "e" => 1}, 1 => %{"c" => 1}} == "ac"
  """

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input"), do: file
    |> String.split("\n", trim: true)
  end

  def find_frequency(list_of_strings, frequency) do
    list_of_strings
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip # boy this is magic
    |> Enum.map(fn(tuple_of_chars) ->
      tuple_of_chars
      |> Tuple.to_list
      |> count_occurrences
      |> frequency.()
      |> List.first
      |> (fn({_, char}) ->  char end).()
    end)
    |> Enum.join
  end

  def count_occurrences(list_of_chars) do
    list_of_chars
    |> Enum.map(&{Enum.count(list_of_chars, fn(x) -> x == &1 end), &1})
    |> Enum.uniq
  end

  def least_frequent(list_of_chars) do
    list_of_chars
    |> Enum.sort
  end

  def most_frequent(list_of_chars) do
    list_of_chars
    |> least_frequent
    |> Enum.reverse
  end

  def p1 do
    load_input()
    |> find_frequency(&most_frequent/1)
  end

  def p2 do
    load_input()
    |> find_frequency(&least_frequent/1)
  end
end
