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
    [x, y] =
      for int1 <- list_of_ints,
          int2 <- Enum.reject(list_of_ints, & &1 == int1) do
        Enum.sort([int1, int2])
      end
      |> Stream.uniq # remove duplicates the cheapo way
      |> Enum.find(fn([int1, int2]) -> int1 + int2 == 2020 end)

    x * y
  end

  @doc """
      iex> p2([1721, 979, 366, 299, 675, 1456])
      241861950
  """
  def p2(list_of_ints) do
    [x, y, z] =
      for int1 <- list_of_ints,
          int2 <- Enum.reject(list_of_ints, & &1 == int1),
          int3 <- Enum.reject(list_of_ints, & &1 == int1 || &1 == int2) do
        Enum.sort([int1, int2, int3])
      end
      |> Stream.uniq # remove duplicates the cheapo way
      |> Enum.find(fn([int1, int2, int3]) -> int1 + int2 + int3 == 2020 end)

    x * y * z
  end
end
