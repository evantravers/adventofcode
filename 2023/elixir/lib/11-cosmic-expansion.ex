defmodule Advent2023.Day11 do
  @behaviour Advent
  @moduledoc """
  https://adventofcode.com/2023/day/11
  """

  def setup do
    with {:ok, file} <- File.read("../input/11") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.graphemes(line)
      end)
    end
  end

  def p1(i) do
    i
  end
  def p2(_i), do: nil
end
