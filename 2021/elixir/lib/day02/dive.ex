defmodule Advent2021.Day2 do
  @moduledoc "https://adventofcode.com/2021/day/2"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
    end
  end

  def p1(input) do
    input
    |> Enum.reduce(%{x: 0, y: 0}, fn
      "forward " <> num, %{x: x} = sub -> %{sub | x: x + String.to_integer(num)}
      "down " <> num, %{y: y} = sub -> %{sub | y: y + String.to_integer(num)}
      "up " <> num, %{y: y} = sub -> %{sub | y: y - String.to_integer(num)}
    end)
    |> Map.values
    |> Enum.product
  end

  def p2(_i), do: nil
end
