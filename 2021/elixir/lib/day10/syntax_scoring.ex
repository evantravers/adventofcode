defmodule Advent2021.Day10 do
  @moduledoc "https://adventofcode.com/2021/day/10"

  @score %{
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
    end
  end

  @doc """
  I feel like this could be a zipper... with pattern matching on the hd() of
  each queue.
  """
  def parse(input, matches \\ [])
  def parse([], matches), do: matches
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

  def p1(list) do
    list
    |> Enum.map(&parse/1)
    |> Enum.filter(fn
      {:corrupted, _char} -> true
      _ -> false
    end)
    |> Enum.map(fn({:corrupted, char}) -> Map.get(@score, char) end)
    |> Enum.sum
  end
  def p2(_i), do: nil
end
