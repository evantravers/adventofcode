alias Graph.Edge

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
        {val, x} <- Enum.with_index(row),
        val != "#"
    do
      {{x, y}, val}
    end
  end

  def build_graph(list, edges \\ [])
  def build_graph([], edges) do
    Graph.new
    |> Graph.add_edges(edges)
  end
  def build_graph([{coord, val}|coords], edges) do
    adjacent =
      coord
      |> valid_moves(coords)
      |> Enum.map(&Edge.new({coord, val}, &1))

    build_graph(coords, adjacent ++ edges)
  end

  def valid_moves({x, y}, list) do
    for target_x <- (x - 1)..(x + 1),
        target_y <- (y - 1)..(y + 1),
        !is_nil(List.keyfind(list, {target_x, target_y}, 0))
    do
      {target_x, target_y}
    end
  end

  def load_input(file \\ "input.txt") do
    {:ok, file} = File.read("#{__DIR__}/#{file}")

    file
  end

  def test do
    "test.txt"
    |> load_input
    |> load_list_of_coords
    |> build_graph
  end

  def p1 do
    "input.txt"
    |> load_input
    |> load_list_of_coords
    |> build_graph
  end

  def p2, do: nil
end
