defmodule Advent2024.Day5 do
  @moduledoc "https://adventofcode.com/2024/day/5"

  def setup do
    with {:ok, file} <- File.read("../input/5") do
      [rules, updates] = String.split(file, "\n\n", trim: true)

      {
        rules
        |> String.split("\n", trim: true)
        |> Enum.map(fn str ->
          str
          |> String.split("|")
          |> Enum.map(&String.to_integer/1)
          |> List.to_tuple
        end),
        updates
        |> String.split("\n", trim: true)
        |> Enum.map(fn str ->
          str
          |> String.split(",", trim: true)
          |> Enum.map(&String.to_integer/1)
        end)
      }
    end
  end

  def sort(a, b, _rules) do
    a < b
  end

  def rule?({a, b}, update) do
    first = Enum.find_index(update, & a == &1) || -10000
    last = Enum.find_index(update, & b == &1) || 10000
    first < last
  end

  def valid?(update, rules) do
    Enum.all?(rules, &rule?(&1, update))
  end

  def p1({rules, updates}) do
    updates
    |> Enum.filter(&valid?(&1, rules))
    |> Enum.map(fn list ->
      middle = floor(length(list) / 2)
      Enum.at(list, middle)
    end)
    |> Enum.sum
  end

  def p2({rules, updates}) do
    updates
    |> Enum.reject(&valid?(&1, rules))
    |> Enum.map(fn update ->
      update
      |> Enum.sort(&sort(&1, &2, rules))

      middle = floor(length(update) / 2)

      Enum.at(update, middle)
    end)
    |> Enum.sum
  end
end
