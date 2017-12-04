defmodule Advent2017 do
  @doc """
  Going to attempt to use streams here.

  I think the first call is:
  `spiral(<target>, :right, 1, 2, %{{0, 0} => 1})`

  Notes:
  - I think interval increases by 1 every two iterations: 1, 2, 2, 3, 3...
  - The structure should look like:
    %{{0, 0} => 1, {1, 0} => 2, {1, 1} => 3 ... }
  - Maybe I should use `get_in` and `put_in` instead... except I need negative
    values. Rats.

  Inteval = length of arm
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

  def next_direction(direction) do
    case direction do
      :right -> :up
      :up -> :left
      :left -> :down
      :down -> :right
    end
  end

  def view_spiral(map) do
    map
    Enum.map((-3..3), fn (x) ->
      Enum.map((-3..3), fn(y) ->
        val = if is_nil(map[{x, y}]), do: " ", else: map[{x, y}]
        IO.binwrite "[#{val}]"
      end)
      IO.puts "\n"
    end)
    IO.puts "\n"
  end

  def spiral(target), do: spiral(target, :right, 1, 0, 1, %{{0, 0} => 1})

  def spiral(target, direction, interval, traveled, turns, map) do

    {coords, last_value} = Enum.at(map, -1)
    view_spiral(map)
    if last_value == target do
      coords
      |> Tuple.to_list
      |> Enum.map(&(abs(&1)))
      |> Enum.sum
    else
      if interval == traveled do
        direction = next_direction(direction)
        turns = turns + 1
        # after we've turned two times, increment the interval
        unless turns > 3 do
          interval = interval + 1
          turns    = 0
        end
      end

      map = Map.merge(map, next_space(coords, direction, last_value + 1))

      spiral(target, direction, interval, traveled+1, turns, map)
    end
  end
end

IO.puts "Part 1: #{Advent2017.spiral(7)}"
