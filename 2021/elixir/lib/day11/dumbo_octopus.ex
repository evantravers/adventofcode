defmodule Advent2021.Day11 do
  @moduledoc "https://adventofcode.com/2021/day/11"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt"), do: setup_string(file)
  end

  def setup_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.reduce(%{}, fn({row, y}, map) ->
      row
      |> String.codepoints
      |> Enum.with_index
      |> Enum.reduce(map, fn({char, x}, map) ->
        Map.put(map, {x, y}, String.to_integer(char))
      end)
    end)
  end

  def increase_energy_level({coord, num}), do: {coord, num + 1}

  def adjacent({{x, y}, _energy}) do
    [
      {x - 1, y - 1},
      {x - 1, y},
      {x - 1, y + 1},
      {x, y - 1},
      {x, y + 1},
      {x + 1, y - 1},
      {x + 1, y},
      {x + 1, y + 1}
    ]
  end

  def flash({_coord, energy}, octopi) when energy <= 9, do: octopi
  def flash({coord, _energy}, octopi) do
    coord
    |> adjacent
    |> Enum.reduce(octopi, fn(flashed, map) ->
      Map.update!(map, flashed, & &1 + 1)
    end)
    |> Map.update!(coord, 0)
  end

  def chain_reaction(octopi) do
    flashed = Enum.reduce(octopi, %{}, &flash/2)

    if flashed == octopi do
      octopi
    else
      chain_reaction(flashed)
    end
  end

  def step(octopi, countdown \\ 100)
  def step(octopi, 0), do: octopi
  def step(octopi, countdown) do
    octopi
    |> Enum.map(&increase_energy_level/1)
    |> chain_reaction
    |> Map.new
    |> step(countdown - 1)
  end

  def p1(octopi) do
    octopi
    |> step(100)
  end

  def p2(_i), do: nil
end
