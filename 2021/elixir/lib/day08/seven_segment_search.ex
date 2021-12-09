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
  https://www.reddit.com/r/adventofcode/comments/rbj87a/comment/hnpfi4k/

  Pre-computing the ideal frequencies.
  """
  def ideal_frequencies do
    ["abcefg","cf","acdeg","acdfg","bcdf","abdfg","abdefg","acf","abcdefg","abcdfg"]
    |> frequency_analysis
    |> Enum.with_index
    |> Enum.map(fn({{_word, sum}, index}) -> {sum, index} end)
    |> Map.new
  end

  def frequency_analysis(signals) do
    map =
    signals
    |> Enum.join
    |> String.codepoints
    |> Enum.frequencies

    signals
    |> Enum.map(fn(str) ->
      {
        str,
        str
        |> String.codepoints
        |> Enum.map(&Map.get(map, &1))
        |> Enum.sum
      }
    end)
  end

  def norm(str) do
    str
    |> String.codepoints
    |> Enum.sort
    |> Enum.join
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
      wiring =
      signals
      |> frequency_analysis
      |> Enum.map(fn({word, sum}) ->
        {norm(word), Map.get(ideal_frequencies(), sum)}
      end)
      |> Map.new

      output
      |> Enum.map(&Map.get(wiring, norm(&1)))
      |> Enum.join
      |> String.to_integer
    end)
    |> Enum.sum
  end
end
