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
  end

  @doc """
  An asteroid is blocked by another asteroid if there's another asteroid
  directly in between them.

  The classic is on the same x/y access.

      iex> [{0,0}, {0, 2}, {0, 4}]
      ...> |> MapSet.new
      ...> |> blocked({0, 0}, {0, 4})
      true

  I should note, this is a two-way relationship... probably could speed up the
  search by memoizing "searched" positions in a two way fashion.
  """
  def blocked(map, {x1, y1} = a1, {x2, y2} = a2) do
    x_distance = x1 - x2
    y_distance = y1 - y2

    map
    |> MapSet.delete(a1)
    |> MapSet.delete(a2)
    |> Enum.any?(fn({x3, y3}) ->
      # FIXME There must be a math function... I think it's something to do
      # with the x1-x2 / y1-y2 ratio.
    end)
  end

  def p1(asteroid_map) do
    asteroid_map
    |> find_station
    |> elem(1)
  end

  def p2(i) do
    i
  end
end
