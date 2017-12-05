defmodule Advent2017 do
  @doc """
  Notes:
  - I think interval increases by 1 every two iterations: 1, 2, 2, 3, 3...
  - The structure should look like:
    [[x: 0, y: 0, value: 1], [x: 1, y: 0, value: 2], [x: 1, y: 1, value: 3] ... ]

  Interval = length of arm
  """

  def next_space(map, direction) do
    last = List.first(map)
    {adjust_x, adjust_y} =
      case direction do
        :right -> {1, 0}
        :up    -> {0, 1}
        :left  -> {-1, 0}
        :down  -> {0, -1}
      end
    [x:     last[:x]+adjust_x,
     y:     last[:y]+adjust_y,
     value: last[:value]+1]
  end

  def next_space_fib(map, direction) do
    last = List.first(map)

    {adjust_x, adjust_y} =
      case direction do
        :right -> {1, 0}
        :up    -> {0, 1}
        :left  -> {-1, 0}
        :down  -> {0, -1}
      end

    new_x = last[:x]+adjust_x
    new_y = last[:y]+adjust_y

    surrounding_value =
      [{1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}, {0, -1}, {1, -1}, {1, 0}]
      |> Enum.map(fn ({x, y}) -> {x+new_x, y+new_y} end) # adjust
      |> Enum.map(fn ({x, y}) -> get(map, {x, y})[:value] end)
      |> Enum.filter(&(is_integer(&1)))
      |> Enum.sum


    [x:     new_x,
     y:     new_y,
     value: surrounding_value]
  end

  @spec next_direction(atom) :: atom
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

  def p1(target), do: spiral(target, &p1_wincondition/2, &next_space/2)
  def p2(target), do: spiral(target, &p2_wincondition/2, &next_space_fib/2)

  def p1_wincondition(target, value), do: target == value
  def p2_wincondition(target, value), do: value > target

  def spiral(map        \\ [[x: 0, y: 0, value: 1]],
             target,
             wincond,
             compute_position,
             direction  \\ :right,
             interval   \\ 1,
             traveled   \\ 0,
             timetogrow \\ false) do
    last = List.first(map)
    # view_spiral(map)

    if wincond.(target, last[:value]) do
      "Value: #{last[:value]}\n" <>
      "Distance: #{abs(last[:x]) + abs(last[:y])}"
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

      map = [compute_position.(map, direction)] ++ map
      spiral(map,
             target,
             wincond,
             compute_position,
             direction,
             interval,
             traveled+1,
             timetogrow)
    end
  end
end

IO.puts "Part 1: #{Advent2017.p1(265149)}"
IO.puts "Part 2: #{Advent2017.p2(265149)}"
