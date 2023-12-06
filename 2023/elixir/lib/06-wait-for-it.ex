defmodule Advent2023.Day6 do
  @moduledoc "https://adventofcode.com/2023/day/6"

  def setup do
    with {:ok, file} <- File.read("../input/6") do
      setup_from_string(file)
    end
  end

  def setup_from_string(str) do
    [time, distance] =
      str
      |> String.split("\n", trim: true)
      |> Enum.map(fn row ->
        [_label, values] = String.split(row, ":")

        values
        |> String.trim
        |> String.split(~r/\s+/)
        |> Enum.map(&String.to_integer/1)
      end)

    Enum.zip(time, distance)
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
  ...> |> setup_from_string
  ...> |> p1
  288
  """
  def p1(races) do
    races
    |> Enum.map(&ways_to_beat/1)
    |> Enum.product
  end

  def p2(_i), do: nil
end
