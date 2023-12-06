defmodule Advent2023.Day5 do
  @moduledoc "https://adventofcode.com/2023/day/5"

  def setup do
    with {:ok, file} <- File.read("../input/5") do
      setup_from_string(file)
    end
  end

  def setup_from_string(str) do
    [
      seeds,
      seed_to_soil,
      soil_to_fertilizer,
      fertilizer_to_water,
      water_to_light,
      light_to_temperature,
      temperature_to_humidity,
      humidity_to_location
    ] = String.split(str, "\n\n", trim: true)

    seeds
  end

  @doc """
  iex> seeds: 79 14 55 13
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
  """
  def p1(input) do
    input
  end

  def p2(_i), do: nil
end
