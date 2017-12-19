defmodule Advent2017.Day19 do
  def mazerunner(maze, start, history) do
    v(maze, start, :d, history)
  end

  def v(maze, pos, direction, history) do
    case maze[pos] do
      "|" -> v(maze, next(pos, direction), direction, history) # continue
      "+" -> turn(maze, pos, direction, history) # turn
      "-" -> v(maze, skip(pos, direction), direction, history) # skip
      _ -> v(maze, skip(pos, direction), direction, [maze[pos]|history] # record and skip
    end
  end

  def h(maze, pos, direction, history) do
    case maze[pos] do
      "-" -> h(maze, next(pos, direction), direction, history) # continue
      "+" -> turn(maze, pos, direction, history) # turn
      "|" -> h(maze, skip(pos, direction), direction, history) # skip
      _ -> h(maze, skip(pos, direction), diretion, [maze[pos]|history]# record and skip
    end
  end

  def next({x, y}, direction) do
    case direction do
      :u -> {x, y+1}
      :d -> {x, y-1}
      :l -> {x-1, y}
      :r -> {x+1, y}
    end
  end

  def skip(coords, direction), do: next(next(coords, direction))

  @doc ~S"""
  returns a tuple of direction and new coordinate {dir, {x, y}}
  """
  def whichway(maze, list_of_coords, target) do
    Enum.find(list_of_coords, fn {dir, coords} ->
      Regex.match?(~r/[a-zA-Z]|#{target}/, Map.get(maze, coords))
    end)
  end

  def turn(maze, pos, previous_direction, history) do
    {x, y} = pos
    case previous_direction do
      :u || :d ->
        {new_dir, new_pos} = whichway(maze, [{:l {x-1, y}}, {:r {x+1, y}}], "-")
        h(maze, new_pos, new_dir, history)
      :l || :r ->
        {new_dir, new_pos} = whichway(maze, [{:d {x, y-1}}, {:u {x, y+1}}], "|")
        v(maze, new_pos, new_dir, history)
    end
  end

  def p1, do: nil
  def p2, do: nil
end
