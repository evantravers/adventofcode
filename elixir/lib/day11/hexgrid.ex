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
    IO.inspect state
    track(future, %{state | step => state[step]+1})
  end

  def distance(state) do
    abs(state[:n] - state[:s]) + abs(state[:ne] - state[:sw]) + abs(state[:nw] - state[:se])
  end

  def p1 do
    {:ok, file} = File.read("lib/day11/input.txt")

    file
    |> track
  end
end
