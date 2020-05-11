defmodule Advent2019.Day10 do
  @moduledoc "https://adventofcode.com/2019/day/10"
  @behaviour Advent

  def setup do
    with {:ok, string} <- File.read("#{__DIR__}/input.txt") do
      process_map(string)
    end
  end

  @spec process_map(String.t) :: MapSet.t
  def process_map(string) do
    rows =
      string
      |> String.split("\n", trim: true)
      |> Enum.with_index

    for {row, y} <- rows,
        {char, x} <- Enum.with_index(String.graphemes(row)),
        char == "#" do
      {x, y}
    end
    |> MapSet.new
  end

  @doc """
  Find the best location for a new monitoring station. How many other asteroids
  can be detected from that location?

      iex> process_map("......#.#.
      ...>#..#.#....
      ...>..#######.
      ...>.#.#.###..
      ...>.#..#.....
      ...>..#....#.#
      ...>#..#....#.
      ...>.##.#..###
      ...>##...#..#.
      ...>.#....####")
      ...> |> find_station
      {{5, 8}, 33}
  """
  def find_station(map) do
    map
    |> Enum.map(fn(asteroid) ->
      {
        asteroid,
        map
        |> MapSet.delete(asteroid)
        |> Enum.count(fn(target) -> !blocked?(map, asteroid, target) end)
      }
    end)
    |> Enum.max_by(&elem(&1, 1))
  end

  @doc """
  An asteroid is blocked by another asteroid if there's another asteroid
  directly in between them.

  The classic definition of a line is y = <slope>x + <offset>.
  Another definition is: y1 - y2 = <slope>(x1 - x2)

  The slope is the change in height divided by the change in horizontal
  distance.

  The classic is on the same x/y access.

      iex> [{0,0}, {0, 2}, {0, 4}]
      ...> |> MapSet.new
      ...> |> blocked?({0, 0}, {0, 4})
      true

      iex> [{0,0}, {2, 0}, {4, 0}]
      ...> |> MapSet.new
      ...> |> blocked?({0, 0}, {4, 0})
      true

      iex> [{0,0}, {2, 1}, {4, 0}]
      ...> |> MapSet.new
      ...> |> blocked?({0, 0}, {4, 0})
      false

  Diagonal

      iex> [{0,0}, {2, 2}, {4, 4}]
      ...> |> MapSet.new
      ...> |> blocked?({0, 0}, {4, 4})
      true

      iex> [{0,0}, {1, 2}, {4, 4}]
      ...> |> MapSet.new
      ...> |> blocked?({0, 0}, {4, 4})
      false

      iex> [{0,0}, {-2, -2}, {4, 4}]
      ...> |> MapSet.new
      ...> |> blocked?({0, 0}, {4, 4})
      false

  More complex...

      iex> [{0,0}, {7, 6}, {14, 12}]
      ...> |> MapSet.new
      ...> |> blocked?({0, 0}, {14, 12})
      true

  I should note, this is a two-way relationship... probably could speed up the
  search by memoizing "searched" positions in a two way fashion.
  """
  def blocked?(map, a1, a2) do
    map
    |> MapSet.delete(a1)
    |> MapSet.delete(a2)
    |> Enum.any?(fn(a3) ->
      collinear?(a1, a2, a3) && between?(a1, a2, a3)
    end)
  end

  @doc """
  is a3 between a1 and a2?
  """
  def between?({x1, y1}, {x2, y2}, {x3, y3}) do
    Enum.member?(x1..x2, x3) && Enum.member?(y1..y2, y3)
  end

  def collinear?({x1, y1}, {x2, y2}, {x3, y3}) do
    (y3 - y2)*(x2 - x1) == (y2 - y1)*(x3 - x2)
  end

  def p1(asteroid_map) do
    asteroid_map
    |> find_station
    |> elem(1)
  end

  @doc """
      iex> ".#..##.###...#######
      ...>##.############..##.
      ...>.#.######.########.#
      ...>.###.#######.####.#.
      ...>#####.##.#.##.###.##
      ...>..#####..#.#########
      ...>####################
      ...>#.####....###.#.#.##
      ...>##.#################
      ...>#####.##.###..####..
      ...>..######..##.#######
      ...>####.##.####...##..#
      ...>.#####..#.######.###
      ...>##...#.##########...
      ...>#.##########.#######
      ...>.####.#.###.###.#.##
      ...>....##.##.###..#####
      ...>.#.#.###########.###
      ...>#.#.#.#####.####.###
      ...>###.##.####.##.#..##"
      ...> |> process_map
      ...> |> p2(200, debug: true)
      {8, 2}
  """
  def p2(_asteroid_map, _num \\ 200, opts \\ []) do
    x = 0
    y = 0

    if opts[:debug] do
      {x, y}
    else
      (x*100 + y)
    end
  end
end
