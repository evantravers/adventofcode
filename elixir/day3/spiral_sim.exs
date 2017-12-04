defmodule Advent2017 do
  @moduledoc """
  distance = steps to midpoint of circle + number of levels you are at

  first circle is 1^2
  second circle is 3^2
  third circle is 5^2
  1,3,5,7

  target = the number we are looking for
  n = a level in the spiral
  d = the diameter of the spiral at that point (1, 3, 5, 7...)
  """


  def find_level(target) do
    possible_values =
      Enum.take_every(1..9999, 2)
      |> Enum.with_index
      |> Enum.drop_while(fn ({number, _}) -> :math.pow(number, 2) < target end)
    {_, level} = hd(possible_values)
    level
  end

  def find_diameter(n) do
    Enum.take_every(1..9999, 2)
    |> Enum.at(n)
  end

  @doc """
  The circle array starts from BR (entry point) and cycles around
  until the end. Each diameter-th index is a corner.
  """
  def distance_from_midpoint(index, diameter) do
         d = diameter - 1
    radius = d/2

    round(abs(radius - rem(index, d)))
  end

  defp distance({circle, level, diameter}, target) do
    index = Enum.find_index(circle, &(target == &1))
    distance_from_midpoint(index, diameter) + level
  end

  @doc """
  Returns a list of the numbers in the circle, starting from the bottom
  right corner and going counter-clockwise. Each diameter-th spot is a
  corner.

  Returns the list, the level, and the diameter
  """
  def simulate_circle(n) do

    # the last ring ends at (d-1)^2 (where d is 1, 3, 5...)
    diameter       = find_diameter(n)
    d_prev         = find_diameter(n-1)
    starting_point = round(:math.pow(d_prev, 2) + 1)

    circle =
      (starting_point..round(:math.pow(diameter, 2)))
      |> Enum.to_list

    # rotate(1): the circle starts from just above BR
    {last, circle} = List.pop_at(circle, -1)
    {[last] ++ circle, n, diameter}
  end

  def distance(num) do
    num
    |> find_level
    |> simulate_circle
    |> distance(num)
  end

  def day3 do
    IO.puts "ghetto tests:\n####################\n"
    IO.puts "12: should be 3 steps: #{distance(12)}"
    IO.puts "23: should be 2 steps: #{distance(23)}"
    IO.puts "1024: should be 31 steps: #{distance(1024)}"

    IO.puts distance(265149)
  end
end

Advent2017.day3
