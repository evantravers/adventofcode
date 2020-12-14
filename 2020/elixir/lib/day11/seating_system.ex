defmodule Advent2020.Day11 do
  @moduledoc "https://adventofcode.com/2020/day/11"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
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
  - If a seat is empty (L) and there are no occupied seats adjacent to it, the
    seat becomes occupied.
  - If a seat is occupied (#) and four or more seats adjacent to it are also
    occupied, the seat becomes empty.  Otherwise, the seat's state does not
    change.
  """
  def next_state(map, {x, y}) do
    case Map.get(map, {x, y}) do
      :empty ->
        if all_adjacent_empty?(map, {x, y}) do
          :occupied
        else
          :empty
        end

      :occupied ->
        if four_or_more_occupied?(map, {x, y}) do
          :empty
        else
          :occupied
        end
    end
  end

  def next_round(map) do
    map
    |> Map.keys
    |> Enum.map(&{&1, next_state(map, &1)})
    |> Enum.into(%{})
  end

  def adjacent_values(map, {x, y}) do
    for adj_x <- (x - 1)..(x + 1), adj_y <- (y - 1)..(y + 1), do: Map.get(map, {adj_x, adj_y})
  end

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
