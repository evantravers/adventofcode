defmodule Advent2020.Day7 do
  @moduledoc "https://adventofcode.com/2020/day/7"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.reduce(Graph.new, &parse_sentence/2)
    end
  end

  @doc """
      iex> parse_bag("2 shiny purple bags")
      %{"number" => 2, "adjective" => "shiny", "color" => "purple"}
  """
  def parse_bag(str) do
    ~r/(\d+ )?(?<adjective>\w+) (?<color>\w+) bags/
    |> Regex.named_captures(str)
  end

  def parse_sentence(sentence, graph) do
    [parent, children_str] = String.split(sentence, " contain ")

    children =
      children_str
      |> String.replace(".", "")
      |> String.split(", ", trim: true)
      |> Enum.map(&parse_bag/1)

    graph
    |> Graph.add_edges(
      for child <- children, do: {parse_bag(parent), child}
    )
  end

  def p1(inventory) do
    inventory
    require IEx; IEx.pry
    # |> Enum.find(fn({parent, children}) ->
    # end)
  end

  def p2(_i), do: nil
end
