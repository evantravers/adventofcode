defmodule Advent2018.Day13 do
  @moduledoc "https://adventofcode.com/2018/day/13"

  def load_track(input \\ "input.txt") do
    with {:ok, file} <- File.read("#{__DIR__}/#{input}") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
    end
  end

  def p1, do: nil
  def p2, do: nil
end
