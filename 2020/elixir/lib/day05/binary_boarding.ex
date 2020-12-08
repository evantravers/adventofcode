defmodule Advent2020.Day5 do
  @moduledoc "https://adventofcode.com/2020/day/5"
  # + 1 = 128
  @rows 127
  # + 1 = 8
  @columns 7

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
    |> String.graphemes()
    |> Enum.reduce(%{row: {0, @rows}, column: {0, @columns}}, &eval/2)
    |> Map.update!(:row, &elem(&1, 0))
    |> Map.update!(:column, &elem(&1, 0))
  end

  def midpoint(low, high), do: high - Integer.floor_div(high - low, 2)

  def binary(map, dimension, :high) do
    Map.update!(map, dimension, fn {low, high} ->
      {midpoint(low, high), high}
    end)
  end

  def binary(map, dimension, :low) do
    Map.update!(map, dimension, fn {low, high} ->
      {low, midpoint(low, high) - 1}
    end)
  end

  def eval("F", map), do: binary(map, :row, :low)
  def eval("B", map), do: binary(map, :row, :high)
  def eval("L", map), do: binary(map, :column, :low)
  def eval("R", map), do: binary(map, :column, :high)

  def seat_id(%{row: r, column: c}), do: r * 8 + c

  def p1(boarding_passes) do
    boarding_passes
    |> Enum.map(&seat_id/1)
    |> Enum.max()
  end

  def p2(boarding_passes) do
    for x <- 0..@rows,
        y <- 0..@columns,
        !Enum.member?(boarding_passes, %{row: x, column: y}) do
      %{row: x, column: y}
    end
    |> Enum.find(fn %{row: row, column: column} ->
      Enum.member?(boarding_passes, %{row: row + 1, column: column}) &&
        Enum.member?(boarding_passes, %{row: row - 1, column: column})
    end)
    |> seat_id
  end
end
