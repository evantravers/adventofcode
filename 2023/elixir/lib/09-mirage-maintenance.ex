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

  def compute_prediction(list_of_integers) do
    list_of_integers
    |> Stream.chunk_every(2, 1)
    |> IO.inspect
  end

  @doc """
  iex> "0 3 6 9 12 15
  ...>1 3 6 10 15 21
  ...>10 13 16 21 30 45"
  ...> |> setup_from_string
  ...> |> p1
  114
  """
  def p1(list_of_numbers) do
    # isn't this basically a Riemann sum / integral kinda thing?
    list_of_numbers
    |> Enum.map(&compute_prediction/1)
    |> Enum.sum
  end

  def p2(_i), do: nil
end
