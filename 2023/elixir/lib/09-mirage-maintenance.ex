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

  def derivative_vector(list_of_integers) do
    list_of_integers
    |> Enum.chunk_every(2, 1)
    |> Enum.reject(&length(&1) == 1)
    |> Enum.map(fn ([a, b]) ->
      b - a
    end)
  end

  def generate_vectors(list_of_integers, history \\ []) do
    der_vector = derivative_vector(list_of_integers)
    if Enum.all?(der_vector, & &1 == 0) do
      [list_of_integers|history]
    else
      generate_vectors(der_vector, [list_of_integers|history])
    end
  end

  def recursive_compute(list_of_integers, inc \\ 0, f)
  def recursive_compute([], inc, _f), do: inc
  def recursive_compute([head|tail], inc, f) do
    recursive_compute(tail, f.(hd(head), inc), f)
  end

  @doc """
  iex> "0 3 6 9 12 15
  ...>1 3 6 10 15 21
  ...>10 13 16 21 30 45"
  ...> |> setup_from_string
  ...> |> p1
  114
  """
  def p1(list_of_lists) do
    # isn't this basically a Riemann sum / integral kinda thing?
    list_of_lists
    |> Enum.map(fn list_of_numbers ->
      list_of_numbers
      |> generate_vectors
      |> Enum.map(&Enum.reverse/1)
      |> recursive_compute(0, &Kernel.+/2)
    end)
    |> Enum.sum
  end

  @doc """
  iex> "0 3 6 9 12 15
  ...>1 3 6 10 15 21
  ...>10 13 16 21 30 45"
  ...> |> setup_from_string
  ...> |> p2
  2
  """
  def p2(list_of_lists) do
    # isn't this basically a Riemann sum / integral kinda thing?
    list_of_lists
    |> Enum.map(fn list_of_numbers ->
      list_of_numbers
      |> generate_vectors
      |> recursive_compute(0, &Kernel.-/2)
    end)
    |> Enum.sum
  end
end
