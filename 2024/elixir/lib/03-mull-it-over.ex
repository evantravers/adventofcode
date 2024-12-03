defmodule Advent2024.Day3 do
  @moduledoc "https://adventofcode.com/2024/day/3"

  def setup do
    with {:ok, file} <- File.read("../input/3") do
      file
      |> String.split("\n", trim: true)
    end
  end

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

  def save_number(context, str) do
    number = String.to_integer(str)
    Map.update(context, :numbers, [number], &[number|&1])
  end

  def parse_number(char, context, str \\ "")
  def parse_number(<<num::binary-size(1)>> <> rest, context, str) when number?(num) do
    parse_number(rest, context, str <> num)
  end
  def parse_number("," <> rest, context, str) do
    parse_number(
      rest,
      save_number(context, str),
      "")
  end
  def parse_number(<<_char::binary-size(1)>> <> rest, context, str) do
    parse(
      rest,
      save_number(context, str)
    )
  end

  @doc """
  iex> p1(["xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"])
  161
  """
  def p1(list_of_strings) do
    list_of_strings
    |> Enum.map(fn(str) ->
    instructions = Regex.scan(~r/mul\(\d+,\d+\)/, str)
      if is_list(instructions) do
        numbers =
          ~r/\d+/
          |> Regex.scan(Enum.join(instructions))
          |> List.flatten

        numbers
        |> Enum.map(&String.to_integer/1)
        |> Enum.chunk_every(2)
        |> Enum.map(fn([a, b]) -> a * b end)
        |> Enum.sum
      end
    end)
    |> Enum.sum
  end

  @doc """
  iex> p2(["xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"])
  48
  """
  def p2(list_of_strings) do
    list_of_strings
    |> Enum.map(&process_multiples/1)
    |> Enum.map(fn %{numbers: numbers} ->
      numbers
      |> Enum.chunk_every(2)
      |> Enum.map(fn [a, b] -> a * b end)
      |> Enum.sum
    end)
    |> Enum.sum
  end
end
