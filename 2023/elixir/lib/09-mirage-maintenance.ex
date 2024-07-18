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

  def acceleration_vector(list_of_integers) do
    list_of_integers
    |> Enum.chunk_every(2, 1)
    |> Enum.reject(&length(&1) == 1)
    |> Enum.map(fn ([a, b]) ->
      b - a
    end)
  end

  def generate_vectors(list_of_integers, history \\ []) do
    acc_vector = acceleration_vector(list_of_integers)
    if Enum.all?(acc_vector, & &1 == 0) do
      [list_of_integers|history]
    else
      generate_vectors(acc_vector, [list_of_integers|history])
    end
  end

  def recursive_compute(list_of_lists) do
    # reverse everything so I can use hd/1 which is way more performant than
    # List.last/1
    list_of_lists
    |> Enum.map(&Enum.reverse/1)
    |> recursive_compute(0)
  end
  def recursive_compute([], inc), do: inc
  def recursive_compute([head|tail], acceleration) do
    recursive_compute(tail, acceleration + hd(head))
  end

  def extend_sequence(list_of_numbers) do
    list_of_numbers
    |> generate_vectors()
    |> recursive_compute()
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
    |> Enum.map(&extend_sequence/1)
    |> Enum.sum
  end

  def p2(_i), do: nil
end
