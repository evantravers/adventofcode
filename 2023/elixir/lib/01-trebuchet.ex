defmodule Advent2023.Day1 do
  require IEx

  @moduledoc "https://adventofcode.com/2023/day/1"

  def setup do
    with {:ok, file} <- File.read("../input/1") do
      file
      |> String.split("\n", trim: true)
    end
  end

  def p("one"),   do: 1
  def p("two"),   do: 2
  def p("three"), do: 3
  def p("four"),  do: 4
  def p("five"),  do: 5
  def p("six"),   do: 6
  def p("seven"), do: 7
  def p("eight"), do: 8
  def p("nine"),  do: 9
  def p(num),     do: String.to_integer(num)

  @doc """
  iex> ["1abc2",
  ...> "pqr3stu8vwx",
  ...> "a1b2c3d4e5f",
  ...> "treb7uchet"]
  ...> |> p1()
  142
  """
  def p1(input) do
    input
    |> Enum.map(fn line ->
      numbers =
        line
        |> String.codepoints
        |> Enum.filter(fn c -> String.match?(c, ~r/\d/) end)
        |> Enum.map(&String.to_integer/1)

      List.first(numbers)*10 + List.last(numbers)
    end)
    |> Enum.sum
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
    input
    |> Enum.map(fn line ->
      numbers =
        ~r/\d|one|two|three|four|five|six|seven|eight|nine/
        |> Regex.scan(line)
        |> List.flatten

      p(List.first(numbers))*10 + p(List.last(numbers))
      |> IO.inspect
    end)
    |> Enum.sum
  end
end
