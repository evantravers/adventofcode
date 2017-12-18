require IEx

defmodule Advent2017.Day11 do
  @doc ~S"""
      iex> Advent2017.Day11.track("ne,ne,ne")
      ...> |> List.first
      ...> |> Advent2017.Day11.distance
      3
      iex> Advent2017.Day11.track("ne,ne,sw,sw")
      ...> |> List.first
      ...> |> Advent2017.Day11.distance
      0
      iex> Advent2017.Day11.track("ne,ne,s,s")
      ...> |> List.first
      ...> |> Advent2017.Day11.distance
      2
      iex> Advent2017.Day11.track("se,sw,se,sw,sw")
      ...> |> List.first
      ...> |> Advent2017.Day11.distance
      3
  """
  def track(steps) do
    steps
    |> String.trim
    |> String.split(",", [trim: true])
    |> Enum.map(&String.to_atom &1)
    |> track([%{x: 0, y: 0, z: 0}])
  end

  def track([], states), do: states
  def track([dir|future], states) do
    track(future, [step(dir, hd(states))|states])
  end

  def step(:n,  c), do: %{c | y: c[:y]+1, z: c[:z]-1}
  def step(:ne, c), do: %{c | x: c[:x]+1, z: c[:z]-1}
  def step(:se, c), do: %{c | x: c[:x]+1, y: c[:y]-1}
  def step(:s,  c), do: %{c | z: c[:z]+1, y: c[:y]-1}
  def step(:sw, c), do: %{c | z: c[:z]+1, x: c[:x]-1}
  def step(:nw, c), do: %{c | y: c[:y]+1, x: c[:x]-1}

  def distance(state) do
    Map.values(state)
    |> Enum.map(&abs &1)
    |> Enum.sum
    |> div(2)
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")
    file
    |> track
    |> List.first
    |> distance
  end

  def p2 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")
    file
    |> track
    |> Enum.map(&distance &1)
    |> Enum.max
  end
end
