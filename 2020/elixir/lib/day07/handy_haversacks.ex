defmodule Advent2020.Day7 do
  @moduledoc "https://adventofcode.com/2020/day/7"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, &parse_sentence/2)
    end
  end

  @doc """
      iex> parse_bag("2 shiny purple bags")
      %{"number" => 2, "adjective" => "shiny", "color" => "purple"}
  """
  def parse_bag(str) do
    ~r/(?<number>\d+ )?(?<adjective>\w+) (?<color>\w+) bags/
    |> Regex.named_captures(str)
  end

  def parse_sentence(sentence, map) do
    [parent, children] = String.split(sentence, " contain ")

    map
    |> Map.put(
      parse_bag(parent),
      children
      |> String.split(", ", trim: true)
      |> Enum.map(&parse_bag/1)
    )
  end

  def p1(inventory) do
    inventory
    |> Enum.find(fn({parent, children}) ->
      # find the bags
    end)
  end

  def p2(_i), do: nil
end
