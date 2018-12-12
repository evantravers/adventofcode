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
    {remainder, %{}}
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

  def p1 do
    load_input()
    |> build_tree
  end

  def p2, do: nil
end
