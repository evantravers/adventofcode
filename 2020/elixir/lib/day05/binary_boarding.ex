defmodule Advent2020.Day5 do
  @moduledoc "https://adventofcode.com/2020/day/5"
  @rows 127 # + 1 = 128
  @columns 7 # + 1 = 8

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_seat/1)
    end
  end

  @doc """
      iex> "FBFBBFFRLR"
      ...> |> parse_seat
      %{row: 44, column: 5}

      iex> "BFFFBBFRRR"
      ...> |> parse_seat
      %{row: 70, column: 7}

      iex> "FFFBBBFRRR"
      ...> |> parse_seat
      %{row: 14, column: 7}

      iex> "BBFFBBFRLL"
      ...> |> parse_seat
      %{row: 102, column: 4}
  """
  def parse_seat(str) do
    str
    |> String.graphemes
    |> Enum.reduce(%{row: {0, @rows}, column: {0, @columns}}, &eval/2)
    |> Map.update!(:row, &elem(&1, 0))
    |> Map.update!(:column, &elem(&1, 0))
  end

  def eval("F", map) do
    Map.update!(map, :row, fn({low, high}) ->
      midpoint = high - Integer.floor_div((high - low), 2)
      {low, midpoint-1}
    end)
  end
  def eval("B", map) do
    Map.update!(map, :row, fn({low, high}) ->
      midpoint = high - Integer.floor_div((high - low), 2)
      {midpoint, high}
    end)
  end
  def eval("L", map) do
    Map.update!(map, :column, fn({low, high}) ->
      midpoint = high - Integer.floor_div((high - low), 2)
      {low, midpoint-1}
    end)
  end
  def eval("R", map) do
    Map.update!(map, :column, fn({low, high}) ->
      midpoint = high - Integer.floor_div((high - low), 2)
      {midpoint, high}
    end)
  end

  def seat_id(%{row: r, column: c}), do: r * 8 + c

  def p1(boarding_passes) do
    boarding_passes
    |> Enum.map(&seat_id/1)
    |> Enum.max
  end
  def p2(_i), do: nil
end
