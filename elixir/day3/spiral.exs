defmodule Advent2017 do
  @doc """
  Going to attempt to use streams here.

  I think the first call is:
  `spiral(<target>, :right, 1, 2, %{{0, 0} => 1})`

  Notes:
  - I think distance increases by 1 every three iterations: 1, 2, 2, 2, 3, 3,
    3...
  - The structure should look like:
    %{{0, 0} => 1, {1, 0} => 2, {1, 1} => 3 ... }
  - Maybe I should use `get_in` and `put_in` instead... except I need negative
    values. Rats.
  """

  def next_space({x, y}, direction, value) do
    {adjust_x, adjust_y} = 
      case direction do
        :right -> {1, 0}
        :up    -> {0, 1}
        :left  -> {-1, 0}
        :down  -> {0, -1}
      end
    %{{x+adjust_x, y+adjust_y} => value}
  end

  def spiral(target), do: spiral(target, :right, 1, 1, %{{0, 0} => 1})

  def spiral(target, direction, distance, duration, map) do
    IO.puts("dir: #{direction}, dist: #{distance}, dur: #{duration}")
    IO.inspect(map)

    {coords, last_value} = Enum.at(map, -1)
    IO.inspect coords
    IO.inspect last_value
    if last_value == target do
      coords
      |> Tuple.to_list
      |> Enum.map(&(abs(&1)))
      |> Enum.sum
    else
      if duration == 0 do
        duration = 2
        direction = case direction do
                      :right -> :up
                      :up -> :left
                      :left -> :down
                      :down -> :right
                    end
      end
      map = Map.merge(map, next_space(coords, direction, last_value + 1))
      spiral(target, direction, distance, duration-1, map)
    end
  end
end

IO.puts "Part 1: #{Advent2017.spiral(9)}"
