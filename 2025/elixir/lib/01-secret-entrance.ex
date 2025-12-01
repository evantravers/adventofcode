defmodule Advent2025.Day1 do
  @moduledoc "https://adventofcode.com/2025/day/1"

  def setup do
    with {:ok, file} <- File.read("../input/01") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&read_instructions/1)
    end
  end

  def read_instructions("L" <> count), do: {:L, String.to_integer(count)}
  def read_instructions("R" <> count), do: {:R, String.to_integer(count)}

  def turn({:L, count}, [pointer|_rest] = locs) do
    [Integer.mod(pointer - count, 100)|locs]
  end
  def turn({:R, count}, [pointer|_rest] = locs) do
    [Integer.mod(pointer + count, 100)|locs]
  end

  def p1(instructions) do
    start = [50]

    instructions
    |> Enum.reduce(start, &turn/2)
    |> Enum.count(& &1 == 0)
  end

  def p2(_setup), do: nil
end
