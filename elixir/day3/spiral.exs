defmodule Advent2017 do
  @doc """
  Going to attempt to use streams here.

  I think the first call is:

  Notes:
  - I think interval increases by 1 every two iterations: 1, 2, 2, 3, 3...
  - The structure should look like:
    [[x: 0, y: 0, value: 1], [x: 1, y: 0, value: 2], [x: 1, y: 1, value: 3] ... ]
  - Maybe I should use `get_in` and `put_in` instead... except I need negative
    values. Rats.

  Inteval = length of arm
  """

  def next_space(position, direction) do
    {adjust_x, adjust_y} =
      case direction do
        :right -> {1, 0}
        :up    -> {0, 1}
        :left  -> {-1, 0}
        :down  -> {0, -1}
      end
    [x:     position[:x]+adjust_x,
     y:     position[:y]+adjust_y,
     value: position[:value]+1]
  end

  def next_direction(direction) do
    case direction do
      :right -> :up
      :up    -> :left
      :left  -> :down
      :down  -> :right
    end
  end

  def get(map, coord) do
    Enum.find(map, fn (position) -> {position[:x], position[:y]} == coord end)
  end

  @doc """
  This visualization is turned 90 because I'm too lazy to write a transpose
  """
  def view_spiral(map) do
    map
    Enum.map((-10..10), fn (x) ->
      Enum.map((-10..10), fn(y) ->
        position = get(map, {x, y})
        val = if is_nil(position), do: " ", else: position[:value]
        IO.binwrite "[#{val}]"
      end)
      IO.puts "\n"
    end)
    IO.puts "\n"
  end

  def spiral(target), do: spiral(target, :right, 1, 0, false, [[x: 0, y: 0, value: 1]])

  def spiral(target, direction, interval, traveled, timetogrow, map) do
    last = List.last(map)
    # view_spiral(map)

    if last[:value] == target do # win condition
      abs(last[:x]) + abs(last[:y])
    else
      if traveled == interval do # time to turn
        direction = next_direction(direction)
        traveled  = 0

        {timetogrow, interval} =
          if timetogrow do
            {false, interval+1}
          else
            {true, interval}
          end
      end

      map = map ++ [next_space(last, direction)]
      spiral(target, direction, interval, traveled+1, timetogrow, map)
    end
  end
end

IO.puts "Part 1: #{Advent2017.spiral(265149)}"
