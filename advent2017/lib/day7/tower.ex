require IEx

defmodule Advent2017.Day7 do
  def read_input(file_name) do
    {:ok, file} = File.read("lib/day7/#{file_name}")
    disc = ~r/(?<name>.+) \((?<weight>\d+)\)( -> (?<children>.+))*/

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(fn (pattern) ->
      Regex.named_captures(disc, pattern)
      |> Map.update("children", [], &(String.split(&1, ", ", [trim: true])))
    end)
    |> Enum.sort
  end

  # take from remaining, put into correct place in tree
  def build_tower(remaining), do: build_tower([], remaining)
  def build_tower(tree, remaining) do
    IO.inspect remaining
  end

  def test do
    read_input("test.txt")
    |> build_tower
  end

  def p1 do
    read_input("input.txt")
  end

  def p2, do: nil
end
