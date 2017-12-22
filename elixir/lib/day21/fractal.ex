defmodule Advent2017.Day21 do
  @glider ".#./..#/###"

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

    @doc """
    Takes in the format of the rule, outputs a set of coordinates of the "true"
    values in a Grid struct
    """
    def new(pattern) when is_binary(pattern) do
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

    def new(coords, size) when is_list(coords) do
      %Grid{coords: MapSet.new(coords), size: size}
    end

    def put(g, coord)do
      %Grid{g | coords: MapSet.put(g.coords, coord)}
    end

    def flip(g) do
      Map.update!(g, :coords, fn coords ->
        coords
        |> Enum.map(fn [x, y] -> [(g.size-1) - x, y] end)
        |> MapSet.new
      end)
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
      Map.update!(g, :coords, &MapSet.new(Enum.map(&1, fn [x, y] -> [y, x] end)))
      |> flip
      |> rotate(num-1)
    end

    def match?(src, target) do
      Enum.any?(all_combinations(src), fn rule ->
        rule.coords == target.coords
      end)
    end

    @doc """
    This function takes a grid and returns a 2d array of Grids to be compared
    against the rules.

    Essentially, I figure out how many possible "buckets" the grid is going to
    be subdivided into. I then iterate over those buckets, and take the
    matching coords from the parent grid and put them in there.

    I then adjust the x and y on the subgrid's coords to fit their new state as
    smaller grids.
    """
    def subdivide(grid) do
      cond do
        rem(grid.size, 2) == 0 -> subdivide(grid, 2)
        rem(grid.size, 3) == 0 -> subdivide(grid, 3)
      end
    end
    def subdivide(grid, subgridsize) do
      number_of_subgrids = div(grid.size, subgridsize)
      subgrid_index = number_of_subgrids - 1
      Enum.map(0..subgrid_index, fn y_offset ->
        Enum.map(0..subgrid_index, fn x_offset ->
          Enum.filter(grid.coords, fn [x, y] ->
            Enum.member?(subrange(subgridsize, x_offset), x)
            &&
            Enum.member?(subrange(subgridsize, y_offset), y)
          end)
          |> Enum.map(fn [x, y] -> [x - x_offset*subgridsize, y - y_offset*subgridsize] end)
          |> Grid.new(subgridsize)
        end)
      end)
    end

    @doc """
    Returns an offset range for subdivide/2.
    """
    def subrange(subgridsize, offset \\ 0) do
      subgridsize*offset..subgridsize*offset+(subgridsize-1)
    end

    def join(grid_of_grids) do
      joinedsize = length(grid_of_grids) * hd(List.flatten(grid_of_grids)).size

      grid_of_grids
      |> Enum.with_index
      |> Enum.map(fn {row, y_offset} ->
        row
        |> Enum.with_index
        |> Enum.map(fn {grid, x_offset} ->
          grid.coords
          |> Enum.map(fn [x, y] ->
            [x + x_offset*grid.size, y + y_offset*grid.size]
          end)
        end)
        |> Enum.concat
      end)
      |> Enum.concat
      |> Grid.new(joinedsize)
    end

    def all_combinations(grid) do
      Enum.map((0..3), fn int -> [rotate(grid, int), flip(rotate(grid, int))] end)
      |> Enum.reduce(&Enum.concat(&1, &2))
    end

    defimpl Inspect do
      @doc """
      Pretty print my weird grid implementation, for debugging.
      """
      def inspect(grid, _) do
        """

        #{
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
        }
        """
      end
    end
  end

  def iterate(grid, rules, count \\ 1)
  def iterate(grid, _, 0), do: grid
  def iterate(grid, rules, count) do
    grid
    |> Grid.subdivide
    |> Enum.map(fn row ->
      Enum.map(row, fn pattern ->
        {_, result} = Enum.find(rules, 0, fn {rule, _} -> Grid.match?(rule, pattern) end)
        result
      end)
    end)
    |> Grid.join
    |> iterate(rules, count - 1)
  end

  def build_rulebook(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(&rule &1)
  end

  @doc """
  Read in a rule from a string and generate a map with every possible matching
  rule leading to the same result pattern
  """
  def rule(rule_string) do
    [pattern, result] =
      String.split(rule_string, " => ", trim: true)
      |> Enum.map(&Grid.new &1)
    {pattern, result}
  end

  def test do
    {:ok, file} = File.read(__DIR__ <> "/test.txt")

    rulebook = build_rulebook file

    grid = Grid.new(@glider)

    iterate(grid, rulebook, 2)
    |> Map.get(:coords)
    |> Enum.count
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    rulebook = build_rulebook file

    grid = Grid.new(@glider)

    iterate(grid, rulebook, 5)
    |> Map.get(:coords)
    |> Enum.count
  end

  def p2 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    rulebook = build_rulebook file

    grid = Grid.new(@glider)

    iterate(grid, rulebook, 18)
    |> Map.get(:coords)
    |> Enum.count
  end
end
