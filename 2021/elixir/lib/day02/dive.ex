defmodule Advent2021.Day2 do
  @moduledoc "https://adventofcode.com/2021/day/2"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
    end
  end

  def i(n), do: String.to_integer(n)

  def p1(input) do
    input
    |> Enum.reduce(%{x: 0, y: 0}, fn
      "forward " <> num, %{x: x} = sub -> %{sub | x: x + i(num)}
      "down " <> num, %{y: y} = sub -> %{sub | y: y + i(num)}
      "up " <> num, %{y: y} = sub -> %{sub | y: y - i(num)}
    end)
    |> Map.values
    |> Enum.product
  end

  def p2(input) do
    input
    |> Enum.reduce(%{x: 0, y: 0, aim: 0}, fn
      "forward " <> num, %{x: x, y: y, aim: aim} = sub -> %{sub | x: x + i(num), y: aim * i(num) + y}
      "down " <> num, %{aim: aim} = sub -> %{sub | aim: aim + i(num)}
      "up " <> num, %{aim: aim} = sub -> %{sub | aim: aim - i(num)}
    end)
    |> Map.delete(:aim)
    |> Map.values
    |> Enum.product
  end
end
