defmodule Advent2020.Day1 do
  @moduledoc "https://adventofcode.com/2020/day/1"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end
  end

  @doc """
      iex> p1([1721, 979, 366, 299, 675, 1456])
      514579
  """
  def p1(list_of_ints) do
    for int1 <- list_of_ints,
        int2 <- list_of_ints do
      [int1, int2]
    end
    |> Enum.find(fn([int1, int2]) -> int1 + int2 == 2020 end)
    |> Enum.reduce(1, & &1 * &2)
  end

  @doc """
      iex> p2([1721, 979, 366, 299, 675, 1456])
      241861950
  """
  def p2(list_of_ints) do
    for int1 <- list_of_ints,
        int2 <- list_of_ints,
        int3 <- list_of_ints do
      [int1, int2, int3]
    end
    |> Enum.find(fn([int1, int2, int3]) -> int1 + int2 + int3 == 2020 end)
    |> Enum.reduce(1, & &1 * &2)
  end
end
