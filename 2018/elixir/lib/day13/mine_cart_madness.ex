defmodule Advent2018.Day13 do
  @moduledoc "https://adventofcode.com/2018/day/13"

  def load_file(input) do
    with {:ok, file} <- File.read("#{__DIR__}/#{input}") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
    end
  end

  def load_cars(map) do
    cars =
      map
      |> Enum.filter(fn({_, val}) -> val =~ ~r/v|\^|\<|\>/ end)
      |> Enum.map(&initialize_car/1)

    {cars, Enum.into(Enum.map(map, &replace_cars_with_track/1), %{})}
  end

  def initialize_car({{x, y}, character}) do
    %{pos: {x, y}, direction: north_or_south(character), next_turn: :left}
  end

  def north_or_south("v"), do: :south
  def north_or_south("^"), do: :north
  def north_or_south(">"), do: :east
  def north_or_south("<"), do: :west

  def replace_cars_with_track({coord, "^"}), do: {coord, "|"}
  def replace_cars_with_track({coord, "v"}), do: {coord, "|"}
  def replace_cars_with_track({coord, ">"}), do: {coord, "-"}
  def replace_cars_with_track({coord, "<"}), do: {coord, "-"}
  def replace_cars_with_track(anything), do: anything

  def print_track({cars, track}) do
    max_x =
      track
      |> Map.keys
      |> Enum.max_by(&elem(&1, 0))
      |> elem(0)
    max_y =
      track
      |> Map.keys
      |> Enum.max_by(&elem(&1, 1))
      |> elem(1)

    for y <- 0..max_y do
      for x <- 0..max_x do
        if Enum.find(cars, fn(%{pos: pos}) -> pos == {x, y} end) do
          "O"
        else
          Map.get(track, {x, y}, " ")
        end
      end
      |> Enum.join
      |> Kernel.<> "\n"
    end
    |> Enum.join
  end

  def load_track(list_of_lists) do
    for {row, y} <- Enum.with_index(list_of_lists),
        {character, x} <- Enum.with_index(row),
        character != " ",
        into: %{} do
      {{x, y}, character}
    end
  end

  def load_input(input \\ "input.txt") do
    input
    |> load_file
    |> load_track
    |> load_cars
  end

  def p1 do
    {cars, track} = load_input()
  end

  def p2, do: nil
end
