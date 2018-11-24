defmodule Advent2017.Day3 do
  import Advent2017.Day3.SpiralSim

  @input 265149

  @moduledoc """
  I wrote a crazy solution at one point that simulated adding layers to the
  onion of the spiral, than calculated it's position given a known starting
  point on the onion. (You can probably `git log -- spiral_sim.exs` to see that
  silliness.)

  I think that for p2, I can use a Map of {Int, Int} -> Int and create a stream
  until it is in the right spot?
  """

  defmodule Spiral do
    @moduledoc """
    Represents a spiral map... to make a spiral on a coordinate grid you loop
    through the cardinal directions, (R, U, L, D). Each leg you do twice, and
    then you increment the length of the leg.
    """
    defstruct(
      direction: {1, 0},
      leg_length: 1,
      steps_remaining: 1,
      legs_remaining: 2,
      coords: %{{0, 0} => 1},
      last: {0, 0}
    )

    def last_value(spiral) do
      Map.get(spiral.coords, spiral.last)
    end
  end

  @doc """
  When a length of a leg reaches 0, we need a new direction.
  """
  def next_direction({1, 0}), do: {0, 1}
  def next_direction({0, 1}), do: {-1, 0}
  def next_direction({-1, 0}), do: {0, -1}
  def next_direction({0, -1}), do: {1, 0}

  def add({x1, y1}, {x2, y2}), do: {x1 + x2, y1 + y2}

  defp add_neighbors(spiral, next) do
    for x <- -1..1 do
      for y <- -1..1 do
        Map.get(spiral.coords, add(next, {x, y}))
      end
    end
    |> List.flatten
    |> Enum.reject(&is_nil/1)
    |> Enum.sum
  end

  @doc """
  Takes a spiral and returns another with the next position calculated and
  added.
  """
  def step(%{steps_remaining: 0} = spiral) do
    spiral
    |> Map.update!(:legs_remaining, & &1 -1)
    |> turn
  end
  def step(spiral) do
    next = add(spiral.last, spiral.direction)

    spiral
    |> Map.update!(:coords, fn(c) ->
      Map.put(c, next, add_neighbors(spiral, next))
    end)
    |> Map.put(:last, next)
    |> Map.update!(:steps_remaining, & &1 - 1)
  end

  def turn(%{legs_remaining: 0} = spiral) do
    spiral
    |> Map.put(:legs_remaining, 2)
    |> Map.update!(:leg_length, & &1 + 1)
    |> turn
  end
  def turn(spiral) do
    spiral
    |> Map.update!(:direction, &next_direction/1)
    |> Map.put(:steps_remaining, spiral.leg_length)
  end

  def run(comparison), do: run(%Spiral{}, comparison)
  def run(spiral, comparison) do
    if comparison.(spiral) do
      spiral
    else
      spiral
      |> step
      |> run(comparison)
    end
  end

  @doc """
  How many steps are required to carry the data from the square identified in
  your puzzle input all the way to the access port? (origin)
  """
  def p1 do
    distance(265149) # this is from SpiralSim
  end

  @doc """
  What is the first value written that is larger than your puzzle input?
  """
  def p2 do
    run(fn(spiral) -> Spiral.last_value(spiral) > @input end)
    |> Spiral.last_value
  end
end
