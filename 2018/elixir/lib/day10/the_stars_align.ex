defmodule Advent2018.Day10 do
  @moduledoc "https://adventofcode.com/2018/day/10"

  def load_input(input \\ "input.txt") do
    with {:ok, file} <- File.read("#{__DIR__}/#{input}") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&read_line/1)
    end
  end

  def read_line(str) do
    [x, y, vx, vy] =
      ~r/-*\d+/
      |> Regex.scan(str)
      |> List.flatten
      |> Enum.map(&String.to_integer/1)

    %{position: {x, y}, velocity: {vx, vy}}
  end

  def move(%{position: {x, y}, velocity: {vx, vy}} = object) do
    %{object | position: {x + vx, y + vy}}
  end

  def print(list_of_objects) do
    positions = list_of_objects |> Enum.map(&Map.get(&1, :position))

    for y <- 0..500 do
      for x <- 0..500 do
        if Enum.member?(positions, {x, y}) do
          "#"
        else
          "."
        end
      end
      |> Enum.join
      |> Kernel.<>("\n")
    end
    |> Enum.join
    |> IO.puts
  end

  def bound_difference({%{position: {_, min}}, %{position: {_, max}}}) do
    max - min
  end

  def bounds(positions) do
    positions
    |> Enum.min_max_by(fn(%{position: {_, y}}) -> y end)
    |> bound_difference
  end

  def loop(positions, previous_bound \\ 1_000_000_000_000, count \\ 0) do
    new_positions =
      positions
      |> Enum.map(&move/1)

    new_bounds = bounds(new_positions)

    if new_bounds > previous_bound do
      {positions, count}
    else
      loop(new_positions, new_bounds, count + 1)
    end
  end

  def p1 do
    load_input()
    |> loop
    |> elem(0)
    |> print
  end

  def p2 do
    load_input()
    |> loop
    |> elem(1)
  end
end
