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

  def build_tree(input, tree \\ Graph.new)
  def build_tree([], tree), do: tree
  def build_tree(input, tree) do
    Map.put(tree,
      input
      |> header
      |> children
      |> metadata
    )
  end

  def header([num_children|[num_data|remainder]], tree) do
  end

  def p1 do
    load_input()
    |> build_tree
  end

  def p2, do: nil
end
