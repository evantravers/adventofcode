defmodule Advent2017.Day21 do
  @moduledoc """
  You find a program trying to generate some art. It uses a strange process
  that involves repeatedly enhancing the detail of an image through a set of
  rules.

  The image consists of a two-dimensional square grid of pixels that are either
  on (#) or off (.). The program always begins with this pattern:

  .#.
  ..#
  ###

  Because the pattern is both 3 pixels wide and 3 pixels tall, it is said to
  have a size of 3.

  Then, the program repeats the following process:

  If the size is evenly divisible by 2, break the pixels up into 2x2 squares,
  and convert each 2x2 square into a 3x3 square by following the corresponding
  enhancement rule.  Otherwise, the size is evenly divisible by 3; break the
  pixels up into 3x3 squares, and convert each 3x3 square into a 4x4 square by
  following the corresponding enhancement rule.  Because each square of pixels
  is replaced by a larger one, the image gains pixels and so its size
  increases.

  The artist's book of enhancement rules is nearby (your puzzle input);
  however, it seems to be missing rules. The artist explains that sometimes,
  one must rotate or flip the input pattern to find a match. (Never rotate or
  flip the output pattern, though.) Each pattern is written concisely: rows are
  listed as single units, ordered top-down, and separated by slashes. For
  example, the following rules correspond to the adjacent patterns:
  """

  defmodule Grid do
    @moduledoc """
    A Grid is a MapSet of coords and a memoized size attribute.

    I'm hoping to do splits and joins between the "patterns" easier here, using
    Enum.with_index to provide an offset...

    To split a Grid, you iterate over the possible slices of coordinates,
    collecting the coordinates in each one and subtracting their size *
    subgrid_index from their [x, y].

    To join any number of Grids, you put them in an 2d list, and add their
    size * subgrid_index to their x and y values.
    """
    defstruct coords: MapSet.new, size: 0

    def put(g, coord)do
      %Grid{g | coords: MapSet.put(g.coords, coord)}
    end

    def flip(g) do
      flipped =
        g.coords
        |> Enum.map(fn [x, y] -> [(g.size-1) - x, y] end)
        |> MapSet.new
      %Grid{g | coords: flipped}
    end

    @doc """
    Rotates the grid 90 degrees clockwise using a transpose and a flip. Is there
    a better way? Maybe.

    By default, rotates 1 time, you can provide an integer (1-3) to keep
    rotating.
    """
    def rotate(g, num \\ 1)
    def rotate(g, num) when num == 0, do: g
    def rotate(g, num) when num > 0 do
      Map.update(g, :coords, MapSet.new, &MapSet.new(Enum.map(&1, fn [x, y] -> [y, x] end)))
      |> flip
      |> rotate(num-1)
    end

    def all_combinations(grid) do
      grid
      # Enum.map((0..3), fn int -> [rotate(grid, int), flip(rotate(grid, int))] end)
      # |> Enum.reduce(&Enum.concat(&1, &2))
    end

    @doc """
    Pretty print my weird grid implementation, for debugging.
    """
    def pp(grid) do
      size = grid.size-1
      Enum.map(0..size, fn y ->
        Enum.map(0..size, fn x ->
          case MapSet.member? grid.coords, [x, y] do
            true -> "#"
            false -> "."
          end
        end)
        |> Enum.join
      end)
      |> Enum.intersperse("\n")
      |> Enum.join
      |> IO.puts
    end
  end

  @doc """
  Read in a rule from a string and generate a map with every possible matching
  rule leading to the same result pattern
  """
  def rule(rule_string, rules \\ %{}) do
    [pattern, result] =
      String.split(rule_string, " => ", trim: true)
      |> Enum.map(&to_grid &1)
    {pattern, result}
  end

  @doc """
  Takes in the format of the rule, outputs a set of coordinates of the "true"
  values in a Grid struct
  """
  def to_grid(pattern) do
    rows = String.split(pattern, "/", trim: true)
    c =
      rows
      |> Enum.with_index
      |> Enum.map(fn {row, y} ->
        String.split(row, "", trim: true)
        |> Enum.with_index
        |> Enum.reduce([], fn {char, x}, list ->
          case char do
            "#" -> [[x, y] | list]
            "." -> list
          end
        end)
      end)
      |> Enum.concat
      |> MapSet.new
    %Grid{coords: c, size: length(rows)}
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    file
    |> String.split("\n", trim: true)
  end
end
