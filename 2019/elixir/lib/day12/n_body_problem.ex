defmodule Advent2019.Day12 do
  @moduledoc "https://adventofcode.com/2019/day/12"
  @behaviour Advent

  def setup do
    with {:ok, string} <- File.read("#{__DIR__}/input.txt"), do: string
  end

  def process_string(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&extract_numbers/1)
  end

  def extract_numbers(str) do
    ~r/-*\d+/
      |> Regex.scan(str)
      |> List.flatten
      |> Enum.map(&String.to_integer/1)
  end

  @doc """
      iex> new_moon([1, 2, 3])
      %{pos: [1, 2, 3], vel: [0, 0, 0]}

      iex> new_moon([1])
      %{pos: [1], vel: [0]}
  """
  def new_moon(coords) do
    %{pos: coords, vel: zeroed_vel(coords)}
  end

  def zeroed_vel(list), do: Enum.map(list, fn _ -> 0 end)

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
    a_pos = Map.get(a, :pos)
    b_pos = Map.get(b, :pos)

    a_vel = Map.get(a, :vel)

    adjust_vel(a, a_vel, a_pos, b_pos)
  end

  def adjust_vel(a, [x, y, z], [a_x, a_y, a_z], [b_x, b_y, b_z]) do
    %{a | vel: [
      x + compute_velocity(a_x, b_x),
      y + compute_velocity(a_y, b_y),
      z + compute_velocity(a_z, b_z),
    ]}
  end

  def adjust_vel(a, [x], [a_x], [b_x]) do
    %{a | vel: [ x + compute_velocity(a_x, b_x) ]}
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
    %{moon | pos: add_lists(pos, vel)}
  end

  @doc """
      iex> add_lists([1, 2, 3], [2, 3, 4])
      [3, 5, 7]

      iex> add_lists([0, 0, 0], [1, -1, 10])
      [1, -1, 10]

      iex> add_lists([1], [2])
      [3]
  """
  def add_lists(a, b) do
    a
    |> Enum.zip(b)
    |> Enum.map(fn({x, y}) -> x + y end)
  end

  def potential_energy(%{pos: [x, y, z]}), do: abs(x) + abs(y) + abs(z)
  def kinetic_energy(%{vel: [x, y, z]}), do: abs(x) + abs(y) + abs(z)
  def total_energy(moon), do: potential_energy(moon) * kinetic_energy(moon)

  # stolen from: https://rosettacode.org/wiki/Least_common_multiple#Elixir
  def gcd(a, 0), do: abs(a)
  def gcd(a, b), do: gcd(b, rem(a, b))

  def lcm(a, b), do: div(abs(a * b), gcd(a, b))

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

  def p1(input) do
    input
    |> process_string
    |> Enum.map(&new_moon/1)
    |> p1(1000)
  end
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

  @doc """
  Given a list of tuples, where {position, velocity}, determine the first time
  the system repeats.
  """
  def find_period(system, history \\ MapSet.new)
  def find_period(system, history) do
    if MapSet.member?(history, system) do
      Enum.count(history)
    else
      system
      |> sim
      |> find_period(MapSet.put(history, system))
    end
  end

  @doc """
  How many steps does it take to reach the first state that exactly matches a
  previous state?

  This could take a while... I guess you'd want to figure out when it's
  approaching a local minimum?

  Realization while driving today... after reading the hint that x, y, z are
  entirely independent, I think I can find independent cycles in x y z, then
  find the least common multiple.

  Could I represent each object as a map of one?
  i.e.: %{pos: {<one var>}, vel: {<one var>}}
  """
  def p2(input) do
    [x_s, y_s, z_s] =
      input
      |> process_string
      |> Enum.zip
      |> Enum.map(fn(tup) ->
        tup
        |> Tuple.to_list
        |> Enum.map(&new_moon(List.wrap(&1))) # store each's position and current velocity
      end)

    [x, y, z] = [find_period(x_s), find_period(y_s), find_period(z_s)]

    x
    |> lcm(y)
    |> lcm(z)
  end
end
