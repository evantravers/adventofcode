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

  def parse(tape, context \\ %{enabled: true})
  def parse("do()" <> rest, c), do: parse(rest, %{c | enabled: true})
  def parse("don't()" <> rest, c), do: parse(rest, %{c | enabled: false})
  def parse("mul(" <> rest, %{enabled: false} = c), do: parse(rest, c)
  def parse("mul(" <> rest, %{enabled: true} = c) do
    parse_number(rest, c)
  end
  def parse(<<_::binary-size(1)>> <> rest, context), do: parse(rest, context)
  def parse("", context), do: context

  @numbers ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

  defguard number?(char) when char in @numbers

  def parse_number(char, context, str \\ "")
  def parse_number(<<num::binary-size(1)>> <> rest, context, str) when number?(num) do
    parse_number(rest, context, str <> num)
  end
  def parse_number(<<_char::binary-size(1)>> <> rest, context, str) do
    String.to_integer(str)
    |> IO.inspect

    parse(rest, context)
  end

  def p1(list_of_strings) do
    list_of_strings
    |> Enum.map(&process_multiples/1)
    |> Enum.sum
  end
  def p2(_i), do: nil
end
