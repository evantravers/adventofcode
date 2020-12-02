defmodule Advent2020.Day2 do
  @moduledoc "https://adventofcode.com/2020/day/2"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
    end
  end

  def parse_line(line, func) do
    [[_str, first, second, char, password]] =
      Regex.scan(~r/(\d+)-(\d+) (\w): (\w+)/, line)

    password = String.graphemes(password)
    first    = String.to_integer(first)
    second   = String.to_integer(second)

    func.(first, second, char, password)
  end

  @doc """
      iex> ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]
      ...> |> p1
      2
  """
  def p1(input) do
    Enum.count(input, fn(line) ->
      parse_line(line, fn(first, second, char, password) ->
        count = Enum.count(password, & &1 == char)

        count >= first && count <= second
      end)
    end)
  end

  @doc """
      iex> ["1-3 a: abcde", "1-3 b: cdefg", "2-9 c: ccccccccc"]
      ...> |> p2
      1
  """
  def p2(input) do
    Enum.count(input, fn(line) ->
      parse_line(line, fn(first, second, char, password) ->
        [
          Enum.at(password, first-1) == char,
          Enum.at(password, second-1) == char
        ]
        |> Enum.count(& &1)
        |> Kernel.==(1)
      end)
    end)
  end
end
