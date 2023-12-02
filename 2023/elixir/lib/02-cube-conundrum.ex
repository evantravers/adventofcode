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
        |> Enum.map(fn rounds ->
          rounds
          |> String.trim
          |> String.split(", ", trim: true)
          |> Enum.map(fn round ->
            [number, color] = String.split(round, " ")

            { String.to_atom(color), String.to_integer(number) }
          end)
          |> Enum.into(%{})
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

  def max_color(rounds, color) do
    rounds
    |> Enum.map(&Map.get(&1, color))
    |> Enum.reject(&is_nil/1)
    |> Enum.max
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
    |> Enum.filter(fn { _label, rounds } ->
      max_color(rounds, :red) <= max_red &&
      max_color(rounds, :green) <= max_green &&
      max_color(rounds, :blue) <= max_blue
    end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.sum
  end

  def p2(_i), do: nil
end
