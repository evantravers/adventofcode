defmodule Advent2023.Day6 do
  @moduledoc "https://adventofcode.com/2023/day/6"

  def setup do
    with {:ok, file} <- File.read("../input/6") do
      file
    end
  end

  def ways_to_beat({time, distance}) do
    0..time
    |> Enum.map(fn(speed) ->
      speed*(time-speed)
    end)
    |> Enum.count(& &1 > distance)
  end

  @doc """
  iex> "Time:      7  15   30
  ...>Distance:  9  40  200"
  ...> |> p1
  288
  """
  def p1(input) do
    [time, distance] =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        [_label, values] = String.split(row, ":")

        values
        |> String.trim
        |> String.split(~r/\s+/)
        |> Enum.map(&String.to_integer/1)
      end)

    races = Enum.zip(time, distance)

    races
    |> Enum.map(&ways_to_beat/1)
    |> Enum.product
  end

  @doc """
  iex> "Time:      7  15   30
  ...>Distance:  9  40  200"
  ...> |> p2
  71503
  """
  def p2(races_bad_kerning) do
    [time, distance] =
      races_bad_kerning
      |> String.split("\n", trim: true)
      |> Enum.map(fn str ->
        Regex.scan(~r/\d+/, str)
        |> List.flatten
        |> Enum.join
        |> String.to_integer
      end)

    ways_to_beat({time, distance}) # TODO: This is really slow
  end
end
