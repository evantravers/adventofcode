defmodule Advent2020.Day11 do
  @moduledoc "https://adventofcode.com/2020/day/11"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      setup_str(file)
    end
  end

  def setup_str(source) do
    source
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {str, y}, map ->
      str
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(map, fn
        {"L", x}, map -> Map.put(map, {x, y}, :empty)
        {"#", x}, map -> Map.put(map, {x, y}, :occupied)
        {".", _x}, map -> map # no-op
      end)
    end)
  end

  def all_adjacent_empty?(map, {x, y}) do
    map
    |> adjacent_values({x, y})
    |> Enum.all?(fn seat -> seat == :empty end)
  end

  def four_or_more_occupied?(map, {x, y}) do
    4 <
      map
      |> adjacent_values({x, y})
      |> Enum.filter(fn seat -> seat == :occupied end)
      |> Enum.count()
  end

  @doc """
  """
  def next_round(prev_map) do
    prev_map
    |> Enum.reduce(%{}, fn
      ({coord, :empty}, next_map) ->
        if all_adjacent_empty?(prev_map, coord) do
          Map.put(next_map, coord, :occupied)
        else
          Map.put(next_map, coord, :empty)
        end
      ({coord, :occupied}, next_map) ->
        if four_or_more_occupied?(prev_map, coord) do
          Map.put(next_map, coord, :empty)
        else
          Map.put(next_map, coord, :occupied)
        end
    end)
  end

  def adjacent_values(map, {x, y}) do
    for adj_x <- (x - 1)..(x + 1), adj_y <- (y - 1)..(y + 1) do
      Map.get(map, {adj_x, adj_y})
    end
    |> Enum.reject(&is_nil/1)
  end

  def print(map) do
    IO.puts("")

    for y <- 0..10 do
      for x <- 0..10 do
        map
        |> Map.get({x, y})
        |> (fn
          (:empty) -> "L"
          (:occupied) -> "#"
          (_) -> "."
        end).()
      end
      |> Enum.join("")
      |> IO.puts
    end

    IO.puts("")

    map
  end

  @doc """
      iex> "L.LL.LL.LL
      ...>LLLLLLL.LL
      ...>L.L.L..L..
      ...>LLLL.LL.LL
      ...>L.LL.LL.LL
      ...>L.LLLLL.LL
      ...>..L.L.....
      ...>LLLLLLLLLL
      ...>L.LLLLLL.L
      ...>L.LLLLL.LL"
      ...> |> setup_str
      ...> |> p1
      37
  """
  def p1(seating) do
    next = next_round(seating)

    if seating == next do
      Enum.count(next, fn({_coord, val}) -> val == :occupied end)
    else
      p1(next)
    end
  end

  def p2(_i), do: nil
end
