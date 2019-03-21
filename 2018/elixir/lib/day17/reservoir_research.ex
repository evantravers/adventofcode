defmodule Advent2018.Day17 do
  @moduledoc "https://adventofcode.com/2018/day/17"

  def load_input(filename) do
    with {:ok, contents} <- File.read("#{__DIR__}/#{filename}") do
      contents
      |> String.split("\n", trim: true)
      |> Enum.map(&scan_clay/1)
      |> List.flatten
      |> MapSet.new
    end
  end

  def scan_clay(line) do
    [x, y_1, y_2] =
      ~r/\d+/
        |> Regex.scan(line)
        |> List.flatten
        |> Enum.map(&String.to_integer/1)

    for y <- y_1..y_2 do
      {x, y}
    end
  end

  @doc ~S"""
      iex> load_input("test") |> run_sim()
      57
  """
  def run_sim(input) do
  end

  def p1, do: nil
  def p2, do: nil
end
