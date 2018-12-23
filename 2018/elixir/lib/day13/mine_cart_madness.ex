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

    {cars, Enum.map(map, &replace_cars_with_track/1)}
  end

  def initialize_car({{x, y}, character}) do
    %{pos: {x, y}, direction: north_or_south(character)}
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

  def p1, do: nil
  def p2, do: nil
end
