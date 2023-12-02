defmodule Advent2023.Day2 do
  @moduledoc "https://adventofcode.com/2023/day/2"

  def setup_from_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [label, games] = String.split(line, ":", trim: true)

      {
        label
        |> String.replace("Game ", "")
        |> String.to_integer,
        games
        |> String.split(";", trim: true)
        |> Enum.reduce(%{}, fn(round, scores) ->
          round
          |> String.trim
          |> String.split(", ", trim: true)
          |> Enum.reduce(scores, fn(round, scores) ->
            [number, color] = String.split(round, " ")

            number = String.to_integer(number)
            color  = String.to_atom(color)

            Map.update(scores, color, number, fn current -> max(current, number) end)
          end)
        end)
      }
    end)
    |> Enum.into(%{})
  end

  def setup do
    with {:ok, file} <- File.read("../input/2") do
      file |> setup_from_string
    end
  end

  @doc """
  iex> "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  ...>Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  ...>Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  ...>Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  ...>Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
  ...> |> setup_from_string
  ...> |> p1
  8
  """
  def p1(games) do
    max_red   = 12
    max_green = 13
    max_blue  = 14

    games
    |> Enum.filter(fn { _label, scores } ->
      Map.get(scores, :red) <= max_red &&
      Map.get(scores, :green) <= max_green &&
      Map.get(scores, :blue) <= max_blue
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum
  end

  @doc """
  iex> "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  ...>Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  ...>Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  ...>Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  ...>Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green"
  ...> |> setup_from_string
  ...> |> p2
  2286
  """
  def p2(games) do
    games
    |> Enum.map(fn { _label, scores } ->
      Map.get(scores, :red) * Map.get(scores, :green) * Map.get(scores, :blue)
    end)
    |> Enum.sum
  end
end
