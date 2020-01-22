defmodule Advent2019.Day12 do
  @moduledoc "https://adventofcode.com/2019/day/12"
  @behaviour Advent

  def setup do
    with {:ok, string} <- File.read("#{__DIR__}/input.txt") do
      load_string(string)
    end
  end

  def load_string(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&new_moon/1)
  end

  @doc """
      iex> {"<x=-1, y=0, z=2>", 1}
      ...> |> new_moon
      %{pos: {-1, 0, 2}, vel: {0, 0, 0}, id: 1}
  """
  def new_moon(str) do
    [x, y, z] =
      ~r/-*\d+/
      |> Regex.scan(str)
      |> List.flatten
      |> Enum.map(&String.to_integer/1)

    %{pos: {x, y, z}, vel: {0, 0, 0}}
  end

  @doc """
  To apply gravity, consider every pair of moons. On each axis (x, y, and z),
  the velocity of each moon changes by exactly +1 or -1 to pull the moons
  together. For example, if Ganymede has an x position of 3, and Callisto has a
  x position of 5, then Ganymede's x velocity changes by +1 (because 5 > 3) and
  Callisto's x velocity changes by -1 (because 3 < 5). However, if the
  positions on a given axis are the same, the velocity on that axis does not
  change for that pair of moons.
  """
  def update_velocities(system) do
    system
    |> Enum.map(fn(moon) ->
      system
      |> List.delete(moon)
      |> Enum.reduce(moon, fn(other_moon, moon) ->
        apply_gravity(moon, other_moon)
      end)
    end)
  end

  def apply_gravity(a, b) do
    {a_x, a_y, a_z} = Map.get(a, :pos)
    {b_x, b_y, b_z} = Map.get(b, :pos)

    {x, y, z} = Map.get(a, :vel)

    %{a | vel: {
      x + compute_velocity(a_x, b_x),
      y + compute_velocity(a_y, b_y),
      z + compute_velocity(a_z, b_z),
    }}
  end

  def compute_velocity(p1, p2) when p1 > p2, do: -1
  def compute_velocity(p1, p2) when p1 < p2, do: 1
  def compute_velocity(p1, p2) when p1 == p2, do: 0

  @doc """
  Once all gravity has been applied, apply velocity: simply add the velocity of
  each moon to its own position. For example, if Europa has a position of x=1,
  y=2, z=3 and a velocity of x=-2, y=0,z=3, then its new position would be
  x=-1, y=2, z=6. This process does not modify the velocity of any moon.
  """
  def update_positions(system), do: Enum.map(system, &apply_velocity/1)

  def apply_velocity(%{pos: pos, vel: vel} = moon) do
    %{moon | pos: add_tuples(pos, vel)}
  end

  @doc """
      iex> add_tuples({1, 2, 3}, {2, 3, 4})
      {3, 5, 7}

      iex> add_tuples({0, 0, 0}, {1, -1, 10})
      {1, -1, 10}
  """
  def add_tuples(a, b) do
    a_list = Tuple.to_list(a)
    b_list = Tuple.to_list(b)

    a_list
    |> Enum.zip(b_list)
    |> Enum.map(fn({x, y}) -> x + y end)
    |> List.to_tuple
  end

  def potential_energy(%{pos: {x, y, z}}), do: abs(x) + abs(y) + abs(z)
  def kinetic_energy(%{vel: {x, y, z}}), do: abs(x) + abs(y) + abs(z)
  def total_energy(moon), do: potential_energy(moon) * kinetic_energy(moon)

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

  def p1(system, count \\ 1_000)
  def p1(system, 0) do
    system
    |> Enum.map(&total_energy/1)
    |> Enum.sum
  end
  def p1(system, count) do
    system
    |> sim
    |> p1(count - 1)
  end

  def p2(i) do
  end
end
