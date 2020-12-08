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
      %{num: 2, color: "shiny purple"}
  """
  def parse_bag(str) do
    ~r/(?:(?<num>\d+) )?(?<color>\w+ \w+) bags?/
    |> Regex.named_captures(str)
    |> Enum.reduce(%{}, fn({k, v}, map) ->
      if String.length(v) == 0 do
        map
      else
        if k == "num" do
          Map.put(map, String.to_atom(k), String.to_integer(v))
        else
          Map.put(map, String.to_atom(k), v)
        end
      end
    end)
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
        for child <- children do
          {
            Map.get(child, :color),
            Map.get(parse_bag(parent), :color),
            [weight: Map.get(child, :num)]
          }
        end
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
    with {:ok, file} <- Graph.Serializers.DOT.serialize(inventory), do: File.write("#{__DIR__}/graph.dot", file)

    target = "shiny gold"

    inventory
    |> Graph.reachable([target])
    |> List.delete(target)
    |> Enum.count
  end

  def p2(_i), do: nil
end
