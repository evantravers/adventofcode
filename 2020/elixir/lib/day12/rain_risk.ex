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
  def deg(0), do: 0
  def deg(num), do: rem(360, num)

  def execute({:N, amount}, %{y: y} = ship), do: %{ship | y: y + amount}
  def execute({:S, amount}, %{y: y} = ship), do: %{ship | y: y - amount}
  def execute({:E, amount}, %{x: x} = ship), do: %{ship | x: x + amount}
  def execute({:W, amount}, %{x: x} = ship), do: %{ship | x: x - amount}
  def execute({:L, amount}, %{head: head} = ship), do: %{ship | head: deg(head - amount)}
  def execute({:R, amount}, %{head: head} = ship), do: %{ship | head: deg(head + amount)}
  def execute({:F, amount}, %{head: 0} = ship), do: execute({:N, amount}, ship)
  def execute({:F, amount}, %{head: 90} = ship), do: execute({:E, amount}, ship)
  def execute({:F, amount}, %{head: 180} = ship), do: execute({:S, amount}, ship)
  def execute({:F, amount}, %{head: 270} = ship), do: execute({:W, amount}, ship)

  @doc """
      iex> [{:F, 10}, {:N, 3}, {:F, 7}, {:R, 90}, {:F, 11}]
      ...> |> p1
      25
  """
  def p1(instructions) do
    ship = %{x: 0, y: 0, head: 90}

    final =
      instructions
      |> Enum.reduce(ship, &execute/2)

    Map.get(final, :x) + Map.get(final, :y)
  end

  def p2(_state), do: nil
end
