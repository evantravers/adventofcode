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

  def p2(_i), do: nil
end
