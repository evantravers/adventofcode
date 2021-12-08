defmodule Advent2021.Day7 do
  @moduledoc "https://adventofcode.com/2021/day/7"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split(~r/,|\n/, trim: true)
      |> Enum.map(&String.to_integer/1)
    end
  end

  @doc """
    As it turns out, crab submarine engines don't burn fuel at a constant rate.
  Instead, each change of 1 step in horizontal position costs 1 more unit of
  fuel than the last: the first step costs 1, the second step costs 2, the
  third step costs 3, and so on.
  """
  def cost(p1, p2) do
    distance = abs(p1 - p2)

    (Integer.pow(distance, 2) + distance)/2
  end

  @doc """
      iex> [16,1,2,0,4,2,7,1,2,14] |> p1
      37
  """
  def p1(crabs) do
    {min, max} = Enum.min_max(crabs)

    for position <- min..max do
      crabs
      |> Enum.map(fn(crab) -> abs(crab - position) end)
      |> Enum.sum
    end
    |> Enum.min
  end

  @doc """
      iex> [16,1,2,0,4,2,7,1,2,14] |> p2
      168.0
  """
  def p2(crabs) do
    {min, max} = Enum.min_max(crabs)

    for position <- min..max do
      crabs
      |> Enum.map(fn(crab) -> cost(crab, position) end)
      |> Enum.sum
    end
    |> Enum.min
  end
end
