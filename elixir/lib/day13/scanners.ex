require IEx

defmodule Advent2017.Day13 do
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
  """
  def firewall_active?(_, nil), do: false
  def firewall_active?(depth, range) do
    rem(depth, (range-1)*2) == 0
  end

  @doc """
  Returns a map of depths => range
  """
  def load_config(filename) do
    {:ok, file} = File.read("lib/day13/#{filename}")

    Regex.scan(~r/\d+/, file)
    |> List.flatten
    |> Enum.map(&String.to_integer &1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple &1)
    |> Enum.into(%{})
  end

  def step(firewalls, delay \\ 0, depth \\ 0, score \\ 0) do
    cond do
      Enum.count(firewalls) == 0 ->
        score
      true ->
        {range, firewalls} = Map.pop(firewalls, depth)

        fault =
          case firewall_active?(depth+delay, range) do
            false -> 0
            true -> depth * range
          end

        step(firewalls, delay, depth+1, score+fault)
    end
  end

  def test do
    load_config("test.txt")
    |> step
  end

  def p1 do
    load_config("input.txt")
    |> step
  end

  @doc ~S"""
      iex> Advent2017.Day13.load_config("test.txt")
      ...> |> Advent2017.Day13.p2(0)
      10
  """
  def p2 do
    load_config("input.txt")
    |> p2(0)
  end
  def p2(firewalls, delay) do
    case step(firewalls, delay) do
      0 -> delay
      _ -> p2(firewalls, delay+1)
    end
  end
end

