defmodule Advent2018.Day11 do
  @moduledoc """
  https://adventofcode.com/2018/day/11
  """

  @input 1309

  @doc """
  The power level in a given fuel cell can be found through the following process:

  - Find the fuel cell's rack ID, which is its X coordinate plus 10.
  - Begin with a power level of the rack ID times the Y coordinate.
  - Increase the power level by the value of the grid serial number (your
    puzzle input).
  - Set the power level to itself multiplied by the rack ID.
  - Keep only the hundreds digit of the power level (so 12345 becomes 3;
    numbers with no hundreds digit become 0).
  - Subtract 5 from the power level.

      iex> powerlevel({3, 5}, 8)
      4
      iex> powerlevel({101, 153}, 71)
      4
  """
  def powerlevel({x, y}, input \\ @input) do
    rack_id = x + 10

    rack_id
    |> Kernel.*(y)
    |> Kernel.+(input)
    |> Kernel.*(rack_id)
    |> get_digit_in_hundredths
    |> Kernel.-(5)
  end

  @doc ~S"""
  There is probably a much faster way to do this... something bitwise

      iex> get_digit_in_hundredths(12345)
      3
  """
  def get_digit_in_hundredths(num) do
    num
    |> Integer.to_charlist
    |> Enum.at(-3)
    |> List.wrap
    |> List.to_string
    |> String.to_integer
  end

  @doc """
  Given an {x, y} as a top-left coordinate, computes the value of the scan area.
  """
  def compute_value(coord, map_of_charges, size \\ 3) do
    coord
    |> scan_area(size)
    |> Enum.map(&Map.get(map_of_charges, &1))
    |> Enum.reject(&is_nil(&1))
    |> Enum.sum
  end

  def scan_area({o_x, o_y}, size) do
    offset = size - 1
    for x <- o_x..(o_x + offset), y <- o_y..(o_y + offset) do
      {x, y}
    end
  end

  @doc """
  Why is it 1-indexed? So unkind. TODO: could result in an off-by-one!

  {1, 1} → {300, 1}

  ↓

  {1, 300}
  """
  def buildmap do
    for x <- 1..300, y <- 1..300 do
      {{x, y}, powerlevel({x, y})}
    end
    |> Enum.into(%{})
  end

  def p1 do
    map_of_charges = buildmap()

    map_of_charges
    |> Enum.map(fn({coord, _}) ->
      {coord, compute_value(coord, map_of_charges)}
    end)
    |> Enum.max_by(&elem(&1, 1))
    |> elem(0)
    |> Tuple.to_list
    |> Enum.join(",")
  end

  def p2 do
    map_of_charges = buildmap()

    map_of_charges
    |> Enum.map(fn({coord, _}) ->
      {final_size, value} =
        for size <- 1..20 do
          {size, compute_value(coord, map_of_charges, size)}
        end
        |> Enum.max_by(&elem(&1, 1))

      {coord, final_size, value}
    end)
    |> Enum.max_by(&elem(&1, 2))
    |> (fn({{x, y}, size, _}) -> "#{x},#{y},#{size}" end).()
  end
end
