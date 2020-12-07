defmodule Advent2020.Day7 do
  @moduledoc "https://adventofcode.com/2020/day/7"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt"), do: setup_str(file)
  end

  def setup_str(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.reduce(Graph.new, &parse_sentence/2)
  end

  @doc """
      iex> parse_bag("2 shiny purple bags")
      %{"adjective" => "shiny", "color" => "purple"}
  """
  def parse_bag(str) do
    ~r/(\d+ )?(?<adjective>\w+) (?<color>\w+) bags?/
    |> Regex.named_captures(str)
  end

  def parse_sentence(sentence, graph) do
    [parent, children_str] = String.split(sentence, " contain ")

    if String.match?(children_str, ~r/no other/) do
      graph
    else
      children =
        children_str
        |> String.replace(".", "")
        |> String.split(", ", trim: true)
        |> Enum.map(&parse_bag/1)

      graph
      |> Graph.add_edges(
        for child <- children, do: {child, parse_bag(parent)}
      )
    end
  end

  @doc """
      iex> "light red bags contain 1 bright white bag, 2 muted yellow bags.
      ...>dark orange bags contain 3 bright white bags, 4 muted yellow bags.
      ...>bright white bags contain 1 shiny gold bag.
      ...>muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
      ...>shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
      ...>dark olive bags contain 3 faded blue bags, 4 dotted black bags.
      ...>vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
      ...>faded blue bags contain no other bags.
      ...>dotted black bags contain no other bags."
      ...> |> setup_str
      ...> |> p1
      4
  """
  def p1(inventory) do
    target = %{"adjective" => "shiny", "color" => "gold"}

    inventory
    |> Graph.reachable([target])
    |> List.delete(target)
    |> Enum.map(&Map.get(&1, "color"))
    |> Enum.count
  end

  def p2(_i), do: nil
end
