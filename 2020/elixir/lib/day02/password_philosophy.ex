defmodule Advent2020.Day2 do
  @moduledoc "https://adventofcode.com/2020/day/2"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
    end
  end

  def parse_line(line) do
    [[_str, low, high, char, password]] =
      Regex.scan(~r/(\d+)-(\d+) (\w): (\w+)/, line)

    low = String.to_integer(low)
    high = String.to_integer(high)

    count =
      password
      |> String.graphemes
      |> Enum.count(& &1 == char)

    count >= low && count <= high
  end

  @doc """
      iex> ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]
      ...> |> p1
      2
  """
  def p1(input), do: Enum.count(input, &parse_line/1)
  def p2(_input), do: nil
end
