defmodule Advent2017.Day7 do
  def build_tower(file_name) do {:ok, file} = File.read("lib/day7/#{file_name}")
    disc = ~r/(?<name>.+) \((?<weight>\d+)\)( -> (?<children>.+))*/

    nodes =
      file
      |> String.split("\n", [trim: true])
      |> Enum.map(fn (pattern) ->
        Regex.named_captures(disc, pattern)
        |> Map.update("children", [], &(String.split(&1, ", ", [trim: true])))
      end)
      |> Enum.sort # put the leaf nodes first, branch nodes last

    IO.inspect nodes

    nodes
    |> Enum.reduce(fn (n, tree) ->
      nil
    end)
  end

  def p1 do
    build_tower("test.txt")
  end

  def p2, do: nil
end
