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
end

