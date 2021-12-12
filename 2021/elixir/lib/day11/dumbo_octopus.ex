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

  @doc """
      iex> increase_energy_level({{1, 1}, 1})
      {{1, 1}, 2}
  """
  def increase_energy_level({:flashes, _count} = flashes), do: flashes
  def increase_energy_level({coord, num}), do: {coord, num + 1}

  def update(octopi, coord) do
    if Map.has_key?(octopi, coord) do
      Map.update!(octopi, coord, & &1 + 1) # FIXME: isn't this increase_energy_level?
    else
      octopi
    end
  end

  def flash({:flashes, _count}, octopi), do: octopi
  def flash({_coord, energy}, octopi) when energy <= 9, do: octopi
  def flash({{x, y}, _energy}, octopi) do
    octopi
    |> update({x - 1, y - 1})
    |> update({x - 1, y})
    |> update({x - 1, y + 1})
    |> update({x, y - 1})
    |> update({x, y + 1})
    |> update({x + 1, y - 1})
    |> update({x + 1, y})
    |> update({x + 1, y + 1})
    |> Map.put({x, y}, 0)
    |> Map.update!(:flashes, & &1 + 1)
  end

  def chain_reaction(octopi) do
    flashed = Enum.reduce(octopi, octopi, &flash/2)

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
    |> Map.new
    |> chain_reaction
    |> step(countdown - 1)
  end

  @doc """
      iex> "5483143223
      ...>2745854711
      ...>5264556173
      ...>6141336146
      ...>6357385478
      ...>4167524645
      ...>2176841721
      ...>6882881134
      ...>4846848554
      ...>5283751526"
      ...> |> setup_string
      ...> |> p1
      1656
  """
  def p1(octopi) do
    octopi
    |> Map.put(:flashes, 0)
    |> step(100)
    |> Map.get(:flashes)
  end

  def p2(_i), do: nil
end
