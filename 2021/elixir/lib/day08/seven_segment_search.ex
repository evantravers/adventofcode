defmodule Advent2021.Day8 do
  @moduledoc "https://adventofcode.com/2021/day/8"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&read/1)
    end
  end

  def read(str) do
    [signals, output] = String.split(str, " | ", trim: true)

    %{
      signals: String.split(signals, " ", trim: true),
      output: String.split(output, " ", trim: true)
    }
  end

  @doc """
      iex> ["abcefg","acdfg","cf","acdeg","bcdf","acf","abdfg","abdefg","abcdefg","abcdfg"]
      ...> |> frequency_analysis
      %{
        "cf"      => 1,
        "acdeg"   => 2,
        "acdfg"  => 3,
        "bcdf"    => 4,
        "abdfg"   => 5,
        "abdefg"  => 6,
        "acf"     => 7,
        "abcdefg" => 8,
        "abcdfg"  => 9,
        "abcefg"  => 0
      }
  """
  def frequency_analysis(signals) do
    map =
    signals
    |> Enum.join
    |> String.codepoints
    |> Enum.frequencies

    signals
    |> Enum.map(fn(str) ->
      {
        str
        |> String.codepoints
        |> Enum.map(&Map.get(map, &1))
        |> Enum.sort
        |> Enum.join,
        str
      }
    end)
    |> Enum.sort_by(fn({magic, _key}) -> magic end)
    |> Enum.reverse
    |> Enum.with_index
    |> Enum.map(fn({{_magic, key}, val}) -> {key, val} end)
    |> Map.new
  end

  def p1(input) do
    input
    |> Enum.map(fn(%{output: output}) ->
      output
      |> Enum.map(&String.length/1)
      |> Enum.count(fn
        2 -> true # 1
        4 -> true # 4
        3 -> true # 7
        7 -> true # 8
        _ -> false
      end)
    end)
    |> Enum.sum
  end

  def p2(input) do
    input
    |> Enum.map(fn(%{signals: signals, output: output}) ->
      decoder = frequency_analysis(signals)

      output
      |> Enum.map(&Map.get(decoder, &1))
      |> Enum.join
      |> String.to_integer
    end)
    |> Enum.sum
  end
end
