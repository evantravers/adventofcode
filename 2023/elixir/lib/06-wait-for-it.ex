defmodule Advent2023.Day6 do
  @moduledoc "https://adventofcode.com/2023/day/6"

  def setup do
    with {:ok, file} <- File.read("../input/6") do
      [time, distance] =
        file
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
  end

  def p1(races) do
    races
    |> IO.inspect
  end

  def p2(_i), do: nil
end
