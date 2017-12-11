require IEx

defmodule Advent2017.Day7 do
  def read_input(file_name) do
    {:ok, file} = File.read("lib/day7/#{file_name}")
    disc = ~r/(?<name>.+) \((?<weight>\d+)\)( -> (?<children>.+))*/

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(fn (pattern) ->
      for {key, val} <- Regex.named_captures(disc, pattern),
      into: %{},
      do: {String.to_atom(key), val}
    end)
    |> Enum.map(fn (pattern) ->
      pattern
      |> Map.update(:children, false, &(String.split(&1, ", ", [trim: true])))
      |> Map.update(:weight, 0, &(String.to_integer(&1)))
    end)
    |> Enum.sort
    |> Enum.reverse # put the branches first
  end

  def build_tower(remaining), do: build_tower([], remaining)
  def build_tower(level, []), do: level # end state?
  def build_tower(level, [current|remaining]) do
    {matches, remainder} = find_children(remaining, List.wrap(current[:children]))

    [ %{current | children: build_tower(matches, remainder)} | level ]
  end

  def find_children(remaining, list_of_names) do
    matches =
      Enum.filter(remaining, fn child ->
        Enum.find(list_of_names, &(&1 == child[:name]))
      end)
    {
      matches,
      remaining
      |> Enum.reject(fn (child) -> Enum.any?(list_of_names, &(&1 == child[:name])) end)
    }
  end

  def test do
    read_input("test.txt")
    |> build_tower
  end

  def p1 do
    read_input("input.txt")
    |> build_tower
  end

  def p2, do: nil
end
