defmodule Day3 do
  @doc """
  Going to attempt to use streams here.

  I think the first call is:
  `spiral(<target>, :right, 1, %{{0, 0} => 1})`

  Notes:
  - I think distance increases by 1 every two iterations: 1, 1, 2, 2, 3, 3...
  """

  def spiral(target, direction, distance, map) do
    {coords, last} = Enum.at(map, -1)
    if last == target
      coords
      |> Tuple.to_list
      |> Enum.map(&(abs(&1)))
      |> Enum.sum
    case direction do
      :right ->
        {1, 0}
        # ...
        spiral(target, :up, distance, map)
      :up ->
        {0, 1}
        # ...
        spiral(target, :left, distance, map)
      :left ->
        {-1, 0}
        # ...
        spiral(target, :down, distance, map)
      :down ->
        {0, -1}
        # ...
        spiral(target, :right, distance, map)
    end
  end
end
