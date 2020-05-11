defmodule Advent2019.Day10 do
  @moduledoc "https://adventofcode.com/2019/day/10"
  @behaviour Advent

  alias :math, as: Math

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
  https://www.dummies.com/programming/c/trigonometry-for-c-programming/

  I think that this _should_ be close enough for military purposes.
  """
  def radians_to_degrees(radians) do
    degrees = radians * 57.2957795
    if degrees < 0 do
      abs(degrees) + 180
    else
      degrees
    end
  end

  def convert_polar({x_origin, y_origin}, {x_target, y_target}) do
    x_length = x_origin - x_target
    y_length = y_origin - y_target

    hypotenuse = Math.sqrt(Math.pow(abs(x_length), 2) + Math.pow(abs(y_length), 2))

    angle =
      if x_length == 0 do
        0.0
      else
        Math.atan((y_length / x_length))
      end

    {hypotenuse, radians_to_degrees(angle)}
  end

  @doc """
  The proper algorithm:
  - start the laser at 0
  - kill the closest target.
  - adopt the angle from the target
  - repeat until 200
  """
  def destroy_asteroid(map, _laser_angle, 0), do: map
  def destroy_asteroid(map, laser_angle, num) do
    # find the next angle in the map that's greater than laser_angle
    target =
      map
      |> Enum.reject(fn({angle, _, _}) -> angle < laser_angle end)
      |> List.first

    if target do
      # destroy the closest asteroid at that angle
      # set laser_angle to the angle of the destroyed asteroid
      # continue
      new_angle = elem(target, 0)
      destroy_asteroid(List.delete(map, target), new_angle, num - 1)
    else
      # if none, set laser_angle to 0 (laser angle is close to 359 or
      # something)
      destroy_asteroid(map, 0, num)
    end
  end

  def p1(station_and_map), do: Map.get(station_and_map, :asteroids)

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
      ...> |> setup_string
      ...> |> p2(200, debug: true)
      {8, 2}
  """
  def p2(station_and_map, num \\ 200, opts \\ []) do
    # convert the map to an array of polar coordinates
    # order by angle, distance, get 200th entry
    # Seems simple enough?
    station = Map.get(station_and_map, :station)

    sorted =
      station_and_map
      |> Map.get(:map)
      |> Enum.reject(& &1 == station)
      |> Enum.map(fn(coords) ->
        {dist, angle} = convert_polar(station, coords)
        {angle, dist, coords}
      end)
      |> Enum.sort

    {_, _, {x, y}} =
      sorted
      |> destroy_asteroid(0, num)
      |> Enum.at(0)

    if opts[:debug] do
      {x, y}
    else
      (x*100 + y)
    end
  end
end
