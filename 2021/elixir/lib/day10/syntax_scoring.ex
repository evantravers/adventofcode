defmodule Advent2021.Day10 do
  @moduledoc "https://adventofcode.com/2021/day/10"

  @corrupted %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.codepoints/1)
      |> Enum.map(&parse/1)
    end
  end

  @doc """
  I feel like this could be a zipper... with pattern matching on the hd() of
  each queue.
  """
  def parse(input, matches \\ [])
  def parse([], incomplete), do: incomplete
  # open
  def parse(["{"|queue], matches), do: parse(queue, ["}"|matches])
  def parse(["("|queue], matches), do: parse(queue, [")"|matches])
  def parse(["["|queue], matches), do: parse(queue, ["]"|matches])
  def parse(["<"|queue], matches), do: parse(queue, [">"|matches])
  # close
  def parse(["}"|queue], ["}"|zip]), do: parse(queue, zip)
  def parse([")"|queue], [")"|zip]), do: parse(queue, zip)
  def parse(["]"|queue], ["]"|zip]), do: parse(queue, zip)
  def parse([">"|queue], [">"|zip]), do: parse(queue, zip)
  # corrupted
  def parse(["}"|_queue], _matches), do: {:corrupted, "}"}
  def parse([")"|_queue], _matches), do: {:corrupted, ")"}
  def parse(["]"|_queue], _matches), do: {:corrupted, "]"}
  def parse([">"|_queue], _matches), do: {:corrupted, ">"}

  def corrupted?({:corrupted, _}), do: true
  def corrupted?(_), do: false

  def score(")"), do: 1
  def score("]"), do: 2
  def score("}"), do: 3
  def score(">"), do: 4

  @doc """
      iex> "])}>"
      ...> |> String.codepoints
      ...> |> autocomplete_score
      294
  """
  def autocomplete_score(codepoints) do
    codepoints
    |> Enum.reduce(0, fn(char, score) ->
      (score * 5) + score(char)
    end)
  end

  def p1(list) do
    list
    |> Enum.filter(&corrupted?/1)
    |> Enum.map(fn({:corrupted, char}) -> Map.get(@corrupted, char) end)
    |> Enum.sum
  end

  def p2(list) do
    incomplete =
    list
    |> Enum.reject(&corrupted?/1)

    incomplete
    |> Enum.map(&autocomplete_score/1)
    |> Enum.sort
    |> Enum.at(ceil(Enum.count(incomplete) / 2) - 1)
  end
end
