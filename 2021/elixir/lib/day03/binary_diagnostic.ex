defmodule Advent2021.Day3 do
  @moduledoc "https://adventofcode.com/2021/day/3"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt"), do: setup_string(file)
  end

  def setup_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
  end

  def frequencies(input, function) do
    length = input |> hd |> Enum.count

    Enum.reduce(0..length, [], fn(num, result) ->
      char =
        input
        |> Enum.map(&Enum.at(&1, num))
        |> Enum.frequencies
        |> function.()
        |> elem(0)

      result ++ [char]
    end)
    |> Enum.join
    |> String.to_integer(2)
  end

  def gamma(input) do
    frequencies(input, fn(freq) -> Enum.max_by(freq, &elem(&1, 1)) end)
  end

  def epsilon(input) do
    frequencies(input, fn(freq) -> Enum.min_by(freq, &elem(&1, 1)) end)
  end

  def filter(list, index \\ 0, function)
  def filter([result], _index, _function) do
    result
    |> Enum.join
    |> String.to_integer(2)
  end
  def filter(list, index, function) do
    char =
      list
      |> Enum.map(&Enum.at(&1, index))
      |> Enum.frequencies
      |> function.()

    list
    |> Enum.filter(&Enum.at(&1, index) == char)
    |> filter(index + 1, function)
  end

  def oxygen(input) do
    filter(input, fn
      (%{"1" => ones, "0" => zeroes}) when ones == zeroes -> "1"
      (%{"1" => ones, "0" => zeroes}) when ones > zeroes -> "1"
      (%{"1" => ones, "0" => zeroes}) when ones < zeroes -> "0"
      (%{"1" => _ones}) -> "1"
      (%{"0" => _zeroes}) -> "0"
    end)
  end

  def co2(input) do
    filter(input, fn
      (%{"1" => ones, "0" => zeroes}) when ones == zeroes -> "0"
      (%{"1" => ones, "0" => zeroes}) when ones > zeroes -> "0"
      (%{"1" => ones, "0" => zeroes}) when ones < zeroes -> "1"
      (%{"1" => _ones}) -> "1"
      (%{"0" => _zeroes}) -> "0"
    end)
  end

  def p1(input) do
    gamma(input) * epsilon(input)
  end

  @doc """
      iex> "00100
      ...>11110
      ...>10110
      ...>10111
      ...>10101
      ...>01111
      ...>00111
      ...>11100
      ...>10000
      ...>11001
      ...>00010
      ...>01010"
      ...> |> setup_string
      ...> |> p2
      230
  """
  def p2(input) do
    oxygen(input) * co2(input)
  end
end
