defmodule Advent2023.Day1 do
  @moduledoc "https://adventofcode.com/2023/day/1"

  def setup do
    with {:ok, file} <- File.read("../input/1") do
      file
      |> String.split("\n", trim: true)
    end
  end

  def p1(input) do
    input
  end

  def p2(input) do
    nil
  end
end
