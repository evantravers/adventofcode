defmodule Advent2018.Day4 do
  @moduledoc "https://adventofcode.com/2018/day/4"

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, &read_line/2)
    end
  end

  @doc """
  What is the ID of the guard you chose multiplied by the minute you chose? (In
  the above example, the answer would be 10 * 24 = 240.)
  """
  def p1 do
  end

  def p2, do: nil
end
