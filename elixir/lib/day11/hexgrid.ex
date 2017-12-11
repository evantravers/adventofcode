require IEx

defmodule Advent2017.Day11 do
  @doc ~S"""
      iex> Advent2017.Day11.track("ne,ne,ne")
      3
      iex> Advent2017.Day11.track("ne,ne,sw,sw")
      0
      iex> Advent2017.Day11.track("ne,ne,s,s")
      2
      iex> Advent2017.Day11.track("se,sw,se,sw,sw")
      3
  """
  def track(steps) do
    steps
    |> String.trim
    |> String.split(",", [trim: true])
    |> Enum.map(&(String.to_atom(&1)))
    |> track(%{n: 0, ne: 0, se: 0, s: 0, sw: 0, nw: 0})
    |> distance
  end
  def track([], state), do: state
  def track([step|future], state) do
    track(future, %{state | step => state[step]+1})
  end

  def eliminate_steps([d1, middle, d2]) do
    diff = Enum.min([d1, d2])
    {d1-diff, middle+diff, d2-diff}
  end

  def distance(state) do
    [n, ne, nw, s, se, sw] = Map.values(state)

    # in a hexgrid, two steps in directions (seperated by one) direction == 1
    {n, ne, se} = eliminate_steps([n, ne, se])
    {ne, se, s} = eliminate_steps([ne, se, s])
    {se, s, sw} = eliminate_steps([se, s, sw])
    {s, sw, nw} = eliminate_steps([s, sw, nw])
    {sw, nw, n} = eliminate_steps([sw, nw, n])
    {nw, n, ne} = eliminate_steps([nw, n, ne])

    # in a hexgrid, opposite directions cancel each other out
    abs(n-s)+abs(ne-sw)+abs(nw-se)
  end

  def p1 do
    {:ok, file} = File.read("lib/day11/input.txt")
    file
    |> track
  end
end
