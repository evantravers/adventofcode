defmodule Advent2018.Day8 do
  @moduledoc "https://adventofcode.com/2018/day/8"

  def load_input(file \\ "input.txt") do
    with {:ok, file} <- File.read("#{__DIR__}/#{file}") do
      file
      |> String.trim
      |> String.split(" ")
      |> Enum.map(&String.to_integer/1)
    end
  end

  def build_tree([num_children|[num_data|remainder]]) do
    {remainder, %{children: []}}
    |> children(num_children)
    |> metadata(num_data)
  end

  def children(input_tree, 0), do: input_tree
  def children({input, tree}, num) do
    {remainder, child} = build_tree(input)

    {remainder, Map.update(tree, :children, [child], & [child|&1])}
    |> children(num - 1)
  end

  def metadata(input_tree, 0), do: input_tree
  def metadata({[data|input], tree}, num) do
    {input, Map.update(tree, :metadata, [data], & [data|&1])}
    |> metadata(num - 1)
  end

  def add_metadata(%{children: [], metadata: data}), do: Enum.sum(data)
  def add_metadata(%{children: children, metadata: data}) do
    Enum.sum(data) + Enum.sum(Enum.map(children, &add_metadata/1))
  end

  @doc """
  If a node has no child nodes, its value is the sum of its metadata entries.
  So, the value of node B is 10+11+12=33, and the value of node D is 99.

  However, if a node does have child nodes, the metadata entries become indexes
  which refer to those child nodes. A metadata entry of 1 refers to the first
  child node, 2 to the second, 3 to the third, and so on. The value of this
  node is the sum of the values of the child nodes referenced by the metadata
  entries.  If a referenced child node does not exist, that reference is
  skipped. A child node can be referenced multiple time and counts each time it
  is referenced. A metadata entry of 0 does not refer to any child node.

  Node A:

      iex> [2, 3, 0, 3, 10, 11, 12, 1, 1, 0, 1, 99, 2, 1, 1, 2]
      ...> |> build_tree()
      ...> |> elem(1)
      ...> |> compute_value
      66

  Node B:

      iex> [0, 3, 10, 11, 12]
      ...> |> build_tree()
      ...> |> elem(1)
      ...> |> compute_value
      33
  """
  def compute_value(nil), do: 0
  def compute_value(%{children: [], metadata: data}), do: Enum.sum(data)
  def compute_value(%{children: children, metadata: data}) do
    data
    |> Enum.map(fn(data_index) ->
      compute_value(Enum.at(Enum.reverse(children), data_index - 1))
    end)
    |> Enum.sum
  end

  def p1 do
    load_input()
    |> build_tree
    |> elem(1)
    |> add_metadata
  end

  def p2 do
    load_input()
    |> build_tree
    |> elem(1)
    |> compute_value
  end
end
