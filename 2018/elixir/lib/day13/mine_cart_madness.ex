defmodule Advent2018.Day13 do
  @moduledoc "https://adventofcode.com/2018/day/13"

  def load_file(input) do
    with {:ok, file} <- File.read("#{__DIR__}/#{input}") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
    end
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
  end

  def p1, do: nil
  def p2, do: nil
end
