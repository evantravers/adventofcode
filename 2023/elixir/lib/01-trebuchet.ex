defmodule Advent2023.Day1 do
  require IEx

  @moduledoc "https://adventofcode.com/2023/day/1"

  def setup do
    with {:ok, file} <- File.read("../input/1") do
      file
      |> String.split("\n", trim: true)
    end
  end

  def process_number("one"),   do: 1
  def process_number("two"),   do: 2
  def process_number("three"), do: 3
  def process_number("four"),  do: 4
  def process_number("five"),  do: 5
  def process_number("six"),   do: 6
  def process_number("seven"), do: 7
  def process_number("eight"), do: 8
  def process_number("nine"),  do: 9
  def process_number(num),     do: String.to_integer(num)

  def solve(input, regex, func) do
    input
    |> Enum.map(fn line ->
      numbers =
        regex
        |> Regex.scan(line)
        |> List.flatten
        |> Enum.map(func)

      List.first(numbers)*10 + List.last(numbers)
    end)
    |> Enum.sum
  end

  @doc """
  iex> ["1abc2",
  ...> "pqr3stu8vwx",
  ...> "a1b2c3d4e5f",
  ...> "treb7uchet"]
  ...> |> p1()
  142
  """
  def p1(input) do
    solve(input, ~r/\d/, &String.to_integer/1)
  end

  @doc """
  iex> ["two1nine",
  ...> "eightwothree",
  ...> "abcone2threexyz",
  ...> "xtwone3four",
  ...> "4nineeightseven2",
  ...> "zoneight234",
  ...> "7pqrstsixteen"]
  ...> |> p2()
  281
  """
  def p2(input) do
    solve(
      input,
      ~r/\d|one|two|three|four|five|six|seven|eight|nine/,
      &process_number/1
    )
  end
end
