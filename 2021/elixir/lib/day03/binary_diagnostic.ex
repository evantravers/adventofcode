defmodule Advent2021.Day3 do
  @moduledoc "https://adventofcode.com/2021/day/3"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt"), do: setup_string(file)
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
      ...> |> p1
      22
  """
  def setup_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&String.codepoints/1)
  end

  def gamma(input) do
    length = input |> hd |> Enum.count

    Enum.reduce(0..length, [], fn(num, result) ->
      char =
        input
        |> Enum.map(&Enum.at(&1, num))
        |> Enum.frequencies
        |> Enum.max_by(&elem(&1, 1))
        |> elem(0)

      result ++ [char]
    end)
    |> Enum.join
    |> String.to_integer(2)
  end

  def epsilon(input) do
    length = input |> hd |> Enum.count

    Enum.reduce(0..length, [], fn(num, result) ->
      char =
        input
        |> Enum.map(&Enum.at(&1, num))
        |> Enum.frequencies
        |> Enum.min_by(&elem(&1, 1))
        |> elem(0)

      result ++ [char]
    end)
    |> Enum.join
    |> String.to_integer(2)
  end

  def p1(input) do
    gamma(input) * epsilon(input)
  end

  def p2(_i), do: nil
end
