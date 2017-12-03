defmodule Day3 do
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
      |> Enum.drop_while(fn ({number, index}) -> :math.pow(number, 2) < target end)
    {_, level} = hd(possible_values)
    level
  end

  def diameter_at_level(n) do
    Enum.take_every(1..9999, 2)
    |> Enum.at(n)
  end

  @doc """
  Returns a list of the numbers in the circle, starting from the bottom
  right corner and going counter-clockwise. Each diameter-th spot is a
  corner.
  """
  def simulate_circle(n) do

    # the last ring ends at (d-1)^2 (where d is 1, 3, 5...)
    diameter       = diameter_at_level(n)
    d_prev         = diameter_at_level(n-1)
    starting_point = round(:math.pow(d_prev, 2) + 1)

    circle =
      (starting_point..round(:math.pow(diameter, 2)))
      |> Enum.to_list

    # rotate(1): the circle starts from just above BR
    {last, circle} = List.pop_at(circle, -1)
    [last] ++ circle
  end

  def distance(num) do
    find_level(num)
  end

  def run do
    IO.puts "ghetto tests"
    IO.puts distance(1) == 0
    IO.puts distance(12) == 3
    IO.puts distance(23) == 2
    IO.puts distance(1024) == 31

    IO.puts distance(265149)
  end
end

IO.inspect Day3.simulate_circle(1)
IO.inspect Day3.simulate_circle(2)
IO.inspect Day3.simulate_circle(3)
Day3.run
