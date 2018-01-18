defmodule Advent2016.Day24 do
  @moduledoc """
  You extract the duct layout for this area from some blueprints you acquired
  and create a map with the relevant locations marked (your puzzle input). 0 is
  your current location, from which the cleaning robot embarks; the other
  numbers are (in no particular order) the locations the robot needs to visit
  at least once each. Walls are marked as #, and open passages are marked as ..
  Numbers behave like open passages.
  """

  def load_list_of_coords(binary) do
    coords =
      binary
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    for {row, y} <- Enum.with_index(coords),
        {val, x} <- Enum.with_index(row)
    do
      {{x, y}, val}
    end
  end

  def load_input(file \\ "input.txt") do
    {:ok, file} = File.read("#{__DIR__}/#{file}")

    file
    |> load_list_of_coords
  end

  def p1, do: nil
  def p2, do: nil
end
