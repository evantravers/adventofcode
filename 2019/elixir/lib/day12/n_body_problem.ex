defmodule Advent2019.Day12 do
  @moduledoc "https://adventofcode.com/2019/day/12"
  @behaviour Advent

  def setup do
    with {:ok, string} <- File.read("#{__DIR__}/input.txt") do
      string
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.map(&new_moon/1)
    end
  end

  @doc """
      iex> {"<x=-1, y=0, z=2>", 1}
      ...> |> new_moon
      %{pos: {-1, 0, 2}, vel: {0, 0, 0}, id: 1}
  """
  def new_moon({str, id}) do
    [x, y, z] =
      ~r/-*\d+/
      |> Regex.scan(str)
      |> List.flatten
      |> Enum.map(&String.to_integer/1)

    %{id: id, pos: {x, y, z}, vel: {0, 0, 0}}
  end

  @doc """
  For each moon compare against all other moons, except the pairs that have
  already been considered.
  """
  def update_velocities(system) do
    system
    |> Enum.reduce({[], []}, fn(moon, {system, visited}) ->
      system
      |> Enum.reject(&Enum.member?(visited, &1))
      # FIXME: Finish this
    end)
  end

  @doc """
  """
  def update_positions(system) do
    system
  end

  @doc """
  Simulate the motion of the moons in time steps. Within each time step, first
  update the velocity of every moon by applying gravity. Then, once all moons'
  velocities have been updated, update the position of every moon by applying
  velocity. Time progresses by one step once all of the positions are updated.
  """
  def sim(system) do
    system
    |> update_velocities
    |> update_positions
  end

  def p1(i) do
   i
  end

  def p2(i) do
    i
  end
end
