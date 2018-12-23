defmodule Advent2018.Day12 do
  @moduledoc """
  https://adventofcode.com/2018/day/12
  """

  def load_input(file \\ "input.txt") do
    with {:ok, input} <- File.read("#{__DIR__}/#{file}") do
      [initial|rules] = String.split(input, "\n", trim: true)

      {extract_initial(initial), extract_rules(rules)}
    end
  end

  def extract_initial(str) do
    ~r/(#|\.)+/
      |> Regex.run(str)
      |> hd
      |> String.graphemes
  end

  def extract_rules(list_of_strings) do
    list_of_strings
    |> Enum.map(fn(str) ->
      str
      |> String.split(" => ")
      |> (fn([pattern, result]) -> {String.graphemes(pattern), result} end).()
    end)
    |> Enum.into(%{})
  end

  def p1 do
    load_input()
  end

  def p2, do: nil
end
