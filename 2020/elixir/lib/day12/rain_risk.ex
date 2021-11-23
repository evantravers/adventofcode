defmodule Advent2020.Day12 do
  @moduledoc "https://adventofcode.com/2020/day/12"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      setup_string(file)
    end
  end

  def setup_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&clean/1)
  end

  def clean(string) do
    code =
      string
      |> String.first
      |> String.to_atom
    num =
      string
      |> String.slice(1..String.length(string))
      |> String.to_integer

    { code, num }
  end

  @doc """
  we are handling angles
  """
  def deg(num) when num < 0, do: 360 - abs(num)
  def deg(num), do: rem(num, 360)

  def ship({:N, amount}, %{y: y} = ship), do: %{ship | y: y + amount}
  def ship({:S, amount}, %{y: y} = ship), do: %{ship | y: y - amount}
  def ship({:E, amount}, %{x: x} = ship), do: %{ship | x: x + amount}
  def ship({:W, amount}, %{x: x} = ship), do: %{ship | x: x - amount}
  def ship({:L, amount}, %{head: head} = ship), do: %{ship | head: deg(head - amount)}
  def ship({:R, amount}, %{head: head} = ship), do: %{ship | head: deg(head + amount)}
  def ship({:F, amount}, %{head: 0} = ship), do: ship({:N, amount}, ship)
  def ship({:F, amount}, %{head: 90} = ship), do: ship({:E, amount}, ship)
  def ship({:F, amount}, %{head: 180} = ship), do: ship({:S, amount}, ship)
  def ship({:F, amount}, %{head: 270} = ship), do: ship({:W, amount}, ship)

  @doc """
      iex> [{:F, 10}, {:N, 3}, {:F, 7}, {:R, 90}, {:F, 11}]
      ...> |> p1
      25
  """
  def p1(instructions) do
    ship = %{x: 0, y: 0, head: 90}

    final =
      instructions
      |> Enum.reduce(ship, &ship/2)

    abs(Map.get(final, :x)) + abs(Map.get(final, :y))
  end

  def point({:N, amount}, %{py: y} = ship), do: %{ship | py: y + amount}
  def point({:S, amount}, %{py: y} = ship), do: %{ship | py: y - amount}
  def point({:E, amount}, %{px: x} = ship), do: %{ship | px: x + amount}
  def point({:W, amount}, %{px: x} = ship), do: %{ship | px: x - amount}
  def point({:L, deg}, %{px: x, py: y} = ship), do: ship
  def point({:R, deg}, %{px: x, py: y} = ship), do: ship
  def point({:F, amount}, ship) do
    ship
    |> Map.update!(:x, & &1 + Map.get(ship, :px))
    |> Map.update!(:y, & &1 + Map.get(ship, :py))
  end

  def p2(instructions) do
    ship = %{x: 0, y: 0, px: -10, py: 1}

    final =
      instructions
      |> Enum.reduce(ship, &point/2)

    abs(Map.get(final, :x)) + abs(Map.get(final, :y))
  end
end
