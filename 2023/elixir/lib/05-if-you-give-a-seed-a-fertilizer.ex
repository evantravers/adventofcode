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
    {dst_start..dst_start+length, src_start..src_start+length}
  end

  def lookup([], number), do: number # fallback
  def lookup([{src, dst}|ranges], number) do
    src_num = Enum.find_index(src, & &1 == number)
    if src_num do
      next = Enum.at(dst, src_num, false)
      if next do
        next
      end
    end

    lookup(ranges, number)
  end

  def trace(number, dst \\ :soil, maps) # starting at seeds
  def trace(number, :location, _maps), do: number
  def trace(number, dst, maps) do
    IO.puts(number)
    IO.puts(dst)
    {{_src, next_dst}, ranges} =
      Enum.find(maps, fn
        {{src, _dst}, _ranges} -> src == dst
        {:seeds, _seeds} -> false
      end)

    IO.puts("let's go")

    IO.puts next_dst

    trace(lookup(ranges, number), next_dst, maps)
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
    input
    |> Map.get(:seeds)
    |> Enum.map(&trace(&1, input))
    |> Enum.min
  end

  def p2(_i), do: nil
end
