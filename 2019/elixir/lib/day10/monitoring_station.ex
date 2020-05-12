defmodule Advent2019.Day10 do
  @moduledoc "https://adventofcode.com/2019/day/10"
  @behaviour Advent

  import ExUnit.Assertions
  alias :math, as: Math
  use Angle

  def setup do
    with {:ok, string} <- File.read("#{__DIR__}/input.txt") do
      setup_string(string)
    end
  end
  def setup_string(string) do
    map = process_map(string)
    {coords, asteroids_detected} = find_station(map)
    %{station: coords, asteroids: asteroids_detected, map: map}
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

  @doc """
  This is hard, because the x, y system is always positive because positive `y`
  is "down."

  Returns {angle, distance, new coord relative to station, old coords}
  (ordered to take advantage of Enum.sort)

      iex> convert_polar({0, 0}, {0, 2})
      {Angle.degrees(180), 2.0, {0, -2}, {0, 2}}

      iex> convert_polar({2, 2}, {2, 0})
      {Angle.degrees(0), 2.0, {0, 2}, {2, 0}}

      iex> convert_polar({2, 2}, {2, 4})
      {Angle.degrees(180), 2.0, {0, -2}, {2, 4}}

      iex> convert_polar({2, 2}, {4, 2})
      {Angle.degrees(90), 2.0, {2, 0}, {4, 2}}

      iex> convert_polar({2, 2}, {0, 2})
      {Angle.degrees(270), 2.0, {-2, 0}, {0, 2}}

      iex> convert_polar({2, 2}, {4, 4})
      {Angle.degrees(135.0), 2.8284271247461903, {2, -2}, {4, 4}}

      iex> convert_polar({2, 2}, {0, 6})
      {Angle.degrees(206.56505117707798), 4.47213595499958, {-2, -4}, {0, 6}}
  """
  def convert_polar({x_origin, y_origin} = _station, {x_target, y_target} = target) do
    x_length = x_target - x_origin
    y_length = y_origin - y_target

    dist = Math.sqrt(Math.pow(abs(x_length), 2) + Math.pow(abs(y_length), 2))

    {quadrant, rise, run} =
      cond do
        x_length >= 0 && y_length > 0 -> {0, x_length, y_length}
        x_length > 0 && y_length <= 0 -> {90, y_length, x_length}
        x_length <= 0 && y_length < 0 -> {180, x_length, y_length}
        x_length < 0 && y_length >= 0 -> {270, y_length, x_length}
      end

    angle =
      if run == 0 do
        Angle.degrees(quadrant)
      else
        with {:ok, rads} <- Angle.Trig.atan((rise / run)),
             {_, degrees} <- Angle.to_degrees(rads)
        do
          Angle.degrees(abs(degrees) + quadrant)
        end
      end

    {angle, dist, {x_length, y_length}, target}
  end

  @doc """
  The proper algorithm:
  - start the laser at 0
  - kill the closest target.
  - adopt the angle from the target
  - repeat until 200
  """
  def destroy_asteroids(map, num, laser_angle \\ ~a(-0.001°)d, destroyed \\ []) do
    if Enum.count(destroyed) == num do
      hd(destroyed)
    else
      # find the next angle in the map that's greater than laser_angle
      target =
        map
        |> Enum.filter(fn({angle, _, _, _}) -> angle > laser_angle end)
        |> List.first

      if target do
        # destroy the closest asteroid at that angle
        # set laser_angle to the angle of the destroyed asteroid
        # continue
        {new_angle, _dist, _coords, _original_coords} = target
        destroy_asteroids(List.delete(map, target), num, new_angle, [target|destroyed])
      else
        # if none, set laser_angle to original (laser angle is close to 359 or
        # something)
        destroy_asteroids(map, num, 0, destroyed)
      end
    end
  end

  def p1(station_and_map), do: Map.get(station_and_map, :asteroids)

  def p2_test() do
    map =
    ".#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##"
|> setup_string

    assert {11, 12} == p2(map, 1, debug: true)
    assert {12, 1} == p2(map, 2, debug: true)
    assert {12, 2} == p2(map, 3, debug: true)
    assert {12, 8} == p2(map, 10, debug: true)

    assert {8, 2} == p2(map, 200, debug: true)
  end

  def p2(station_and_map, num \\ 200, opts \\ []) do
    # convert the map to an array of polar coordinates
    # order by angle, distance, get 200th entry
    # Seems simple enough?
    station = Map.get(station_and_map, :station)

    sorted =
      station_and_map
      |> Map.get(:map)
      |> Enum.reject(& &1 == station)
      |> Enum.map(fn(coords) -> convert_polar(station, coords) end)
      |> Enum.sort

    {_angle, _dist, _new_coords, {x, y}} =
      sorted
      |> destroy_asteroids(num)

    if opts[:debug] do
      {x, y}
    else
      (x*100 + y)
    end
  end
end
