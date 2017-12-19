require IEx

defmodule Advent2017.Day19 do
  @moduledoc """
  The map file structure is indexed like

       y[0]
        |
  x[0] -+- x+
        |
       y+
  """

  def mazerunner(maze, start, history \\ []) do
    v(maze, start, :d, history)
  end

  def v(maze, pos, direction, history) do
    n = get(maze, pos)
    case n do
      "|" -> v(maze, next(pos, direction), direction, [n|history]) # continue
      "+" -> turn(maze, pos, direction, [n|history]) # turn
      "-" -> v(maze, next(pos, direction), direction, [n|history]) # skip
      " " -> Enum.reverse(history)
      _ -> v(maze, next(pos, direction), direction, [n|history]) # record and skip
    end
  end

  def h(maze, pos, direction, history) do
    n = get(maze, pos)
    case get(maze, pos) do
      "-" -> h(maze, next(pos, direction), direction, [n|history]) # continue
      "+" -> turn(maze, pos, direction, [n|history]) # turn
      "|" -> h(maze, next(pos, direction), direction, [n|history]) # skip
      " " -> Enum.reverse(history)
      _ -> h(maze, next(pos, direction), direction, [n|history]) # record and skip
    end
  end

  def next([x, y], direction) do
    case direction do
      :u -> [x, y-1]
      :d -> [x, y+1]
      :l -> [x-1, y]
      :r -> [x+1, y]
    end
  end

  @doc ~S"""
  returns a tuple of direction and new coordinate {dir, {x, y}}
  """
  def whichway(maze, list_of_coords, target) do
    Enum.find(list_of_coords, fn {_, coords} ->
      get(maze, coords) == target || Regex.match?(~r/[A-Z]/, "#{get(maze, coords)}")
    end)
  end

  def turn(maze, pos, previous_direction, history) do
    [x, y] = pos
    case previous_direction do
      vert when vert == :u or vert == :d ->
        {new_dir, new_pos} = whichway(maze, [{:l, [x-1, y]}, {:r, [x+1, y]}], "-")
        h(maze, new_pos, new_dir, history)
      hor when hor == :l or hor == :r ->
        {new_dir, new_pos} = whichway(maze, [{:u, [x, y-1]}, {:d, [x, y+1]}], "|")
        v(maze, new_pos, new_dir, history)
    end
  end

  def get(maze, [x, y]), do: get_in(maze, [y, x]) # map isn't transposed

  @doc """
  returns {start_pos, maze}
  """
  def load_maze(filename) do
    {:ok, file} = File.read(__DIR__ <> "/#{filename}")

    start = Enum.find_index(String.graphemes(file), &"|" == &1)

    # load the array into a map
    maze =
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Advent2017.Day14.list_grid_to_map_grid

    {[start, 0], maze}
  end

  def test do
    {start, maze} = load_maze("test.txt")
    mazerunner(maze, start)
    |> Enum.filter(&Regex.match?(~r/[A-Z]/, &1))
    |> Enum.join
  end

  def p1 do
    {start, maze} = load_maze("input.txt")
    mazerunner(maze, start)
    |> Enum.filter(&Regex.match?(~r/[A-Z]/, &1))
    |> Enum.join
  end
  def p2 do
    {start, maze} = load_maze("input.txt")
    mazerunner(maze, start)
    |> Enum.count
  end
end
