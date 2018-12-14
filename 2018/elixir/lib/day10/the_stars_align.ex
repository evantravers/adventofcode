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

  def bounds(list_of_objects, :x), do: bounds(list_of_objects, 0)
  def bounds(list_of_objects, :y), do: bounds(list_of_objects, 1)
  def bounds(list_of_objects, x_or_y) do
    list_of_objects
    |> Enum.map(&(elem(Map.get(&1, :position), x_or_y)))
    |> Enum.min_max
  end

  def print(list_of_objects) do
    positions = list_of_objects |> Enum.map(&Map.get(&1, :position))
    {min_x, max_x} = bounds(list_of_objects, :x)
    {min_y, max_y} = bounds(list_of_objects, :y)

    for y <- min_y..max_y do
      for x <- min_x..max_x do
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
  end

  def loop(positions, previous_bound \\ 1_000_000_000_000, count \\ 0) do
    new_positions = Enum.map(positions, &move/1)
    {min, max}    = bounds(new_positions, :y)
    new_bounds    = max - min

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
