defmodule Advent2019.Day1 do
  @moduledoc "https://adventofcode.com/2019/day/1"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end
  end

  @doc """
  Fuel required to launch a given module is based on its mass. Specifically, to
  find the fuel required for a module, take its mass, divide by three, round
  down, and subtract 2.

      iex> fuel_required(12)
      2

      iex> fuel_required(14)
      2

      iex> fuel_required(1969)
      654

      iex> fuel_required(100756)
      33583
  """
  def fuel_required(module_mass) do
    module_mass
    |> Integer.floor_div(3)
    |> Kernel.-(2)
  end

  @doc """
  So, for each module mass, calculate its fuel and add it to the total. Then,
  treat the fuel amount you just calculated as the input mass and repeat the
  process, continuing until a fuel requirement is zero or negative. For
  example:

      iex> total_fuel_required(14)
      2

      iex> total_fuel_required(1969)
      966

      iex> total_fuel_required(100756)
      50346
  """
  def total_fuel_required(mass) when is_integer(mass), do: total_fuel_required([mass])
  def total_fuel_required([mass|_] = total) do
    if fuel_required(mass) > 0 do
      total_fuel_required([fuel_required(mass)|total])
    else
      # wishful thinking
      total
      |> Enum.reverse
      |> tl
      |> Enum.sum
    end
  end

  def p1 do
    setup()
    |> Enum.map(&fuel_required/1)
    |> Enum.sum
  end

  def p2 do
    setup()
    |> Enum.map(&total_fuel_required/1)
    |> Enum.sum
  end
end
