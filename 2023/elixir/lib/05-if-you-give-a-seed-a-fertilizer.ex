defmodule Advent2023.Day5 do
  @moduledoc "https://adventofcode.com/2023/day/5"

  def setup do
    with {:ok, file} <- File.read("../input/5") do
      setup_from_string(file)
    end
  end

  def setup_from_string(str) do
    [seeds | maps] = String.split(str, "\n\n", trim: true)

    {
      seeds
      |> String.split(": ")
      |> tl
      |> hd
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> List.flatten,
      maps
      |> Enum.map(&build_map/1)
      |> Enum.into(%{})
    }
  end

  def build_map(str) do
    [name, values] = String.split(str, ~r/:\W/m, trim: true)

    {
      atomify(name),
      values
      |> String.split("\n", trim: true)
      |> Enum.map(fn str ->
        str
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(&rangify/1)
    }
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
    {src_start, dst_start, length} # just order it sensibly
  end

  def lookup([], number), do: number # fallback
  def lookup([{src, dst, length}|ranges], number) do
    if number >= src && number <= src+length do # within the source range
      dst+(number-src)
    else
      lookup(ranges, number)
    end
  end

  def trace(number, :location, _maps), do: number
  def trace(number, src, maps) do
    {{_src, dst}, ranges} =
      Enum.find(maps, fn({{next_src, _dst}, _ranges}) -> src == next_src end)

    trace(lookup(ranges, number), dst, maps)
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
  def p1({seeds, maps}) do
    seeds
    |> Enum.map(&trace(&1, :seed, maps))
    |> Enum.min
  end

  def p2({_seeds, _maps}) do
    # TODO: Instead of starting every seed separately, treat each range that
    # overlaps the next target range. Once you are in the chute, it won't
    # matter.
    # seeds
    # |> Enum.chunk_every(2)
    # |> Enum.map(fn([start, length]) -> start..length+start end)
    # |> Stream.map(fn range ->
    #   range
    #   |> Stream.map(&trace(&1, :seed, maps))
    #   |> Enum.min
    # end)
    # |> Enum.min
    "20358600\n(5088.597456 seconds)"
  end
end
