defmodule Advent2021.Day8 do
  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&read/1)
    end
  end

  def read(str) do
    [signals, output] = String.split(str, " | ", trim: true)

    %{
      signals: String.split(signals, " ", trim: true),
      output: String.split(output, " ", trim: true)
    }
  end

  def display(%{a: true, b: true, c: true, d: false, e: true, f: true, g: true}), do: 0

  def p1(input) do
    input
    |> Enum.map(fn(%{output: output}) ->
      output
      |> Enum.map(&String.length/1)
      |> Enum.count(fn
        2 -> true # 1
        4 -> true # 4
        3 -> true # 7
        7 -> true # 8
        _ -> false
      end)
    end)
    |> Enum.sum
  end

  def p2(_i), do: nil
end
