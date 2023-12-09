defmodule Advent2023.Day9 do
  @moduledoc "https://adventofcode.com/2023/day/9"

  def setup do
    with {:ok, file} <- File.read("../input/9") do
      setup_from_string(file)
    end
  end

  def setup_from_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      row
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  iex> "0 3 6 9 12 15
  ...>1 3 6 10 15 21
  ...>10 13 16 21 30 45"
  ...> |> setup_from_string
  ...> |> p1
  114
  """
  def p1(i) do
    # isn't this basically a riemann sum / integral kinda thing?
  end

  def p2(_i), do: nil
end
