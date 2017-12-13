defmodule Advent2017.Day13 do
  @doc ~S"""
  Given a clock and a firewall tuple, returns whether the firewall is occuring.

      iex> Advent2017.Day13.firewall_active?(0, {0, 2})
      true
      iex> Advent2017.Day13.firewall_active?(1, {0, 2})
      false
      iex> Advent2017.Day13.firewall_active?(2, {0, 2})
      true

      iex> Advent2017.Day13.firewall_active?(0, {0, 3})
      true
      iex> Advent2017.Day13.firewall_active?(1, {0, 3})
      false
      iex> Advent2017.Day13.firewall_active?(2, {0, 3})
      false
      iex> Advent2017.Day13.firewall_active?(3, {0, 3})
      false
      iex> Advent2017.Day13.firewall_active?(4, {0, 3})
      true
  """
  def firewall_active?(clock, {_, range}) do
    rem(clock, (range-1)*2) == 0
  end

  def load_config(filename) do
    {:ok, file} = File.read("lib/day13/#{filename}")

    Regex.scan(~r/\d+/, file)
    |> List.flatten
    |> Enum.map(&String.to_integer &1)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple &1)
  end
end

