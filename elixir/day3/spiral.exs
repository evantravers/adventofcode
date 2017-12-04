defmodule Advent2017 do
  @doc """
  Going to attempt to use streams here.

  I think the first call is:
  `spiral(<target>, :right, 1, 2, %{{0, 0} => 1})`

  Notes:
  - I think distance increases by 1 every two iterations: 1, 1, 2, 2, 3, 3...
  - The structure should look like:
    %{{0, 0} => 1, {1, 0} => 2, {1, 1} => 3 ... }
  """

  def spiral(target) do: spiral(target, :right, 1, 2, %{})

  def spiral(target, direction, distance, duration, map) do
    {coords, last} = Enum.at(map, -1)
    if last == target do
      coords
      |> Tuple.to_list
      |> Enum.map(&(abs(&1)))
      |> Enum.sum
    else
      if duration > 0 do
        spiral(target, direction, distance, duration-1, map)
      else
        case direction do
          :right ->
            next_space = {1, 0}
            # ...
            spiral(target, :up, distance, map)
          :up ->
            next_space = {0, 1}
            # ...
            spiral(target, :left, distance, map)
          :left ->
            next_space = {-1, 0}
            # ...
            spiral(target, :down, distance, map)
          :down ->
            next_space = {0, -1}
            # ...
            spiral(target, :right, distance, map)
        end
      end
    end
  end
end

Advent2017.spiral(12)
