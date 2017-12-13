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
  def firewall_active?(depth, range) do
    rem(depth, (range-1)*2) == 0
  end

  @doc """
  Returns a map of depths => range
  """
  def load_config(filename) do
    {:ok, file} = File.read("lib/day13/#{filename}")

    input =
      Regex.scan(~r/\d+/, file)
      |> List.flatten
      |> Enum.map(&String.to_integer &1)
      |> Enum.chunk_every(2)
      |> Enum.map(&List.to_tuple &1)
      |> Enum.into(%{})
  end

  def step(firewalls, depth \\ 0, delay \\ 0, score \\ 0) do
    cond do
      Enum.count(firewalls) == 0 ->
        score
      true ->
        {range, firewalls} = Map.pop(firewalls, depth)

        fault = 0

        if !is_nil range do
          if firewall_active?(depth+delay, range) do
            fault = depth*range
          end
        end

        step(firewalls, depth+1, delay, score+fault)
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
end

