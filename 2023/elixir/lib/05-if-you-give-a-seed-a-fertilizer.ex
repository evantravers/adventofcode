defmodule Advent2023.Day5 do
  @moduledoc "https://adventofcode.com/2023/day/5"

  def setup do
    with {:ok, file} <- File.read("../input/5") do
      setup_from_string(file)
    end
  end

  def setup_from_string(str) do
    [seeds | maps] =
      str
      |> String.split("\n\n", trim: true)

    maps
    |> Enum.map(&build_map/1)
    |> Enum.into(%{})
    |> Map.put(
      :seeds,
      seeds
      |> String.split(": ")
      |> tl
      |> hd
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.flatten
    )
  end

  def atomify(name) do
    str = String.replace(name, " map", "")

    destructure([src, dst], String.split(str, "-to-"))

    if dst do
      {String.to_atom(src), String.to_atom(dst)}
    else
      {String.to_atom(src)}
    end
  end

  def rangify([dst_start, src_start, length]) do
    {Range.new(dst_start, dst_start+length), Range.new(src_start, src_start+length)}
  end

  def build_map(str) do
    [name, values] = String.split(str, ~r/:\W/m, trim: true)

    {
      atomify(name),
      values
      |> String.split("\n", trim: true)
      |> IO.inspect
      |> Enum.map(fn str ->
        str
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(&rangify/1)
    }
  end

  @doc """
  iex> "seeds: 79 14 55 13
  ...>
  ...>seed-to-soil map:
  ...>50 98 2
  ...>52 50 48
  ...>
  ...>soil-to-fertilizer map:
  ...>0 15 37
  ...>37 52 2
  ...>39 0 15
  ...>
  ...>fertilizer-to-water map:
  ...>49 53 8
  ...>0 11 42
  ...>42 0 7
  ...>57 7 4
  ...>
  ...>water-to-light map:
  ...>88 18 7
  ...>18 25 70
  ...>
  ...>light-to-temperature map:
  ...>45 77 23
  ...>81 45 19
  ...>68 64 13
  ...>
  ...>temperature-to-humidity map:
  ...>0 69 1
  ...>1 0 69
  ...>
  ...>humidity-to-location map:
  ...>60 56 37
  ...>56 93 4"
  ...> |> setup_from_string
  ...> |> p1
  35
  """
  def p1(input) do
    IO.inspect(input)

    # seeds
    # |> Enum.map(&trace(input, &1))
  end

  def p2(_i), do: nil
end
