require IEx

defmodule Advent2017.Day13 do
  @moduledoc "Solution for Day13"

  @doc ~S"""
  Given a depth and a firewall tuple, returns whether the firewall is occuring.

      iex> Advent2017.Day13.firewall_active?(0, 2)
      true
      iex> Advent2017.Day13.firewall_active?(1, 2)
      false
      iex> Advent2017.Day13.firewall_active?(2, 2)
      true

      iex> Advent2017.Day13.firewall_active?(0, 3)
      true
      iex> Advent2017.Day13.firewall_active?(1, 3)
      false
      iex> Advent2017.Day13.firewall_active?(2, 3)
      false
      iex> Advent2017.Day13.firewall_active?(3, 3)
      false
      iex> Advent2017.Day13.firewall_active?(4, 3)
      true

      iex> Advent2017.Day13.firewall_active?(0, 4)
      true
      iex> Advent2017.Day13.firewall_active?(1, 4)
      false
      iex> Advent2017.Day13.firewall_active?(2, 4)
      false
      iex> Advent2017.Day13.firewall_active?(3, 4)
      false
      iex> Advent2017.Day13.firewall_active?(4, 4)
      false
      iex> Advent2017.Day13.firewall_active?(5, 4)
      false
      iex> Advent2017.Day13.firewall_active?(6, 4)
      true
  """
  def firewall_active?(_, nil), do: false
  def firewall_active?(depth, range) do
    rem(depth, (range - 1) * 2) == 0
  end

  @doc """
  Returns a map of depths => range
  """
  def load_config(filename) do
    {:ok, file} = File.read("#{__DIR__}/#{filename}")

    ~r/\d+/
    |> Regex.scan(file)
    |> List.flatten
    |> Enum.map(&String.to_integer &1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple &1)
    |> Enum.into(%{})
  end

  def step_with_score(firewalls, delay \\ 0, depth \\ 0, score \\ 0)
  def step_with_score(firewalls, _, _, score) when firewalls == %{}, do: score
  def step_with_score(firewalls, delay, depth, score) do
    {range, firewalls} = Map.pop(firewalls, depth)

    fault =
      case firewall_active?(depth + delay, range) do
        false -> 0
        true -> depth * range
      end

    step_with_score(firewalls, delay, depth + 1, score + fault)
  end

  def test do
    "test.txt"
    |> load_config
    |> step_with_score
  end

  def p1 do
    "input.txt"
    |> load_config
    |> step_with_score
  end

  @doc ~S"""
      iex> Advent2017.Day13.load_config("test.txt")
      ...> |> Advent2017.Day13.p2(0)
      10
  """
  def p2 do
    "input.txt"
    |> load_config
    |> Enum.reduce(0..5_000_000, fn({depth, range}, delays)->
      Enum.reject(delays, fn(delay) ->
        firewall_active?(depth+delay, range)
      end)
    end)
    |> Enum.min
  end
end

