defmodule Advent2024.Day5 do
  @moduledoc "https://adventofcode.com/2024/day/5"

  def setup do
    with {:ok, file} <- File.read("../input/5") do
      [rules, updates] = String.split(file, "\n\n", trim: true)

      rules =
        rules
        |> String.split("\n", trim: true)
        |> Enum.map(fn str ->
          str
          |> String.split("|")
          |> Enum.map(&String.to_integer/1)
        end)

      updates =
        updates
        |> Enum.map(fn str ->
          str
          |> String.split("\n", trim: true)
          |> Enum.map(&String.split(&1, ",", trim: true))
          |> Enum.map(&String.to_integer/1)
        end)

      {rules, updates}
    end
  end

  def p1({rules, updates}) do
    updates
  end

  def p2(_i), do: nil
end
