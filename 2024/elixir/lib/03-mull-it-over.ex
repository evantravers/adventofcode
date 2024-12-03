defmodule Advent2024.Day3 do
  @moduledoc "https://adventofcode.com/2024/day/3"

  def setup do
    with {:ok, file} <- File.read("../input/3") do
      file
      |> String.split("\n", trim: true)
    end
  end

  @doc """
  iex> process_multiples("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
  161
  """
  def process_multiples(str), do: parse(str)

  def parse(tape, enabled \\ true)
  def parse("do()" <> rest, _enabled), do: parse(rest, true)
  def parse("don't()" <> rest, _enabled), do: parse(rest, false)
  def parse("mul(" <> rest, false), do: parse(rest, false)
  def parse("mul(" <> rest, true) do
    parse_number(rest)
  end
  def parse(<<_::binary-size(1)>> <> rest, enabled), do: parse(rest, enabled)
  def parse("", _enabled), do: "yay!"

  @numbers ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

  defguard number?(char) when char in @numbers

  def parse_number(char, str \\ "")
  def parse_number(<<num::binary-size(1)>> <> rest, str) when number?(num) do
    parse_number(rest, str <> num)
  end
  def parse_number(<<char::binary-size(1)>> <> rest, str) do
    String.to_integer(str)

    parse(rest, true)
  end

  def p1(list_of_strings) do
    list_of_strings
    |> Enum.map(&process_multiples/1)
    |> Enum.sum
  end
  def p2(_i), do: nil
end
