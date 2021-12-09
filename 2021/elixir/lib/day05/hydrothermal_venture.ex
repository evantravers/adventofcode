defmodule Advent2021.Day5 do
  @moduledoc "https://adventofcode.com/2021/day/5"

  def setup do
    with {:ok, f} <- File.read("#{__DIR__}/input.txt"), do: setup_string(f)
  end

  def setup_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.reduce([], fn(str, acc) ->
      [start_x, start_y, end_x, end_y] =
        ~r/\d+/
        |> Regex.scan(str)
        |> List.flatten
        |> Enum.map(&String.to_integer/1)

      [{start_x..end_x, start_y..end_y}|acc]
    end)
  end

  def cross?({x1, y1}, {x2, y2}) do
    !Range.disjoint?(x1, x2) && !Range.disjoint?(y1, y2)
  end

  @doc """
      iex> cross({0..3, 0..0}, {0..0, 3..0})
      {0, 0}

      iex> cross({1..3, 1..3}, {1..1, 3..0})
      {1, 1}
  """
  def cross({x1, y1}, {x2, y2}) do
    {
      Enum.find(x1, &Enum.member?(x2, &1)),
      Enum.find(y1, &Enum.member?(y2, &1))
    }
  end

  def generate_points({x1..x2, y1..y2}) do
    for x <- x1..x2, y <- y1..y2, do: {x, y}
  end

  @doc """
      iex> "0,9 -> 5,9
      ...>8,0 -> 0,8
      ...>9,4 -> 3,4
      ...>2,2 -> 2,1
      ...>7,0 -> 7,4
      ...>6,4 -> 2,0
      ...>0,9 -> 2,9
      ...>3,4 -> 1,4
      ...>0,0 -> 8,8
      ...>5,5 -> 8,2"
      ...> |> setup_string
      ...> |> p1
      5
  """
  def p1(list) do
    list
    |> Enum.filter(fn({x1..x2, y1..y2}) -> x1 == x2 || y1 == y2 end)
    |> Enum.map(&generate_points/1)
    |> List.flatten
    |> Enum.frequencies
    |> Map.values
    |> Enum.count(& &1 > 1)
  end

  def p2(list) do
    # take every item in the list
    # compare against the other items in the list
    # find the coords where they cross
    # put in a MapSet for history
    # count the MapSet
  end
end
