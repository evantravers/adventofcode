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
    straight(maze, {:d, start}, history)
  end

  @doc """
  We've hit a "+" node, and we are going to turn. Turn identifies which coords
  to check, and calls whichway on them to determine which fork is valid.
  """
  def turn(maze, [x, y], previous_direction, history) do
    pose = case previous_direction do
      d when d in [:u, :d] ->
        whichway(maze, [{:l, [x-1, y]}, {:r, [x+1, y]}], "-")
      d when d in [:l, :r] ->
        whichway(maze, [{:u, [x, y-1]}, {:d, [x, y+1]}], "|")
    end
    straight(maze, pose, history)
  end


  @doc """
  Keep moving in the current direction, until we hit a "+" for a turn.  At
  first I was catching all the different cases possible, but it turns out we
  just keep moving straight until we hit a turn, recording all the things we
  pass.
  """
  def straight(maze, {direction, pos}, history) do
    case n = get(maze, pos) do
      "+" -> turn(maze, pos, direction, [n|history])
      " " -> Enum.reverse(history)
      _ -> straight(maze, {direction, next(pos, direction)}, [n|history])
    end
  end

  @doc """
  Return the next coordinate in a direction.
  """
  def next([x, y], :u), do: [x, y-1]
  def next([x, y], :d), do: [x, y+1]
  def next([x, y], :l), do: [x-1, y]
  def next([x, y], :r), do: [x+1, y]

  @doc """
  All turns are 90 degree turns from the current point in the current direction.
  Valid turns are either a new line character ("-" or "|") or a letter.

  Returns a tuple of direction and new coordinate {dir, {x, y}}
  """
  def whichway(maze, list_of_coords, target) do
    Enum.find(list_of_coords, fn {_, coords} ->
      get(maze, coords) == target || Regex.match?(~r/[A-Z]/, "#{get(maze, coords)}")
    end)
  end

  @doc """
  A quick wrapper for get_in that "transposes" the map
  """
  def get(maze, [x, y]), do: get_in(maze, [y, x])

  @doc """
  Maze is a 2d grid turned into a map for bound detection
  """
  @spec load_maze(String) :: {List, Map}
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
