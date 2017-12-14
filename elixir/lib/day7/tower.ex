require IEx

defmodule Advent2017.Day7 do
  @doc """
  Tree Structure %{"id" => %{tree: %{}, weight: 0}}
  """
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
      |> Map.update(:children, false, fn children ->
        (String.split(children, ", ", [trim: true]))
        |> Enum.map(fn child -> {child, nil} end)
        |> Enum.into(%{})
      end)
      |> Map.update(:weight, 0, &(String.to_integer(&1)))
    end)
    |> Enum.map(fn(n) ->
      {n[:name], %{tree: n[:children], weight: n[:weight]}}
    end)
    |> Enum.into(%{})
  end

  @doc """
  - find its children on the nodes and put it in the right place
  - put it on the back of nodes
  - continue until there is only one node
  """
  def build_tower(nodes) when length(nodes) == 1, do: nodes
  def build_tower([n|nodes]) when is_binary(n) do # unbuilt leaf
  end
  def build_tower([n|nodes]) when is_map(n) do # tree node
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
