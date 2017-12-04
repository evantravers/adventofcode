defmodule Day3 do
  def spiral(direction \\ :right, distance, map) do
    case direction do
      :right ->
        {1, 0}
      :up ->
        {0, 1}
      :left ->
        {-1, 0}
      :down ->
        {0, -1}
    end
  end
end
