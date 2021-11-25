defmodule Advent2020.Day15 do
  @moduledoc "https://adventofcode.com/2020/day/15"
  @behaviour Advent

  def setup do
    setup_game([0,5,4,1,10,14,7])
  end

  def setup_game(array) do
    Enum.reduce(array, %{turn: 1}, fn(num, history) ->
      history
      |> say(num)
      |> next_turn
    end)
  end

  def next_turn(history), do: Map.update!(history, :turn, & &1 + 1)

  def last_said(history, last), do: Map.get(history, last) |> tl |> hd

  def say(%{turn: turn} = history, value) do
    history
    |> Map.update(value, [turn], &[turn | &1])
    |> Map.put(:last, value)
  end

  @doc """
      iex> [0,3,6]
      ...> |> setup_game
      ...> |> p1
      436
  """
  def p1(%{turn: 2021, last: last}), do: last
  def p1(%{turn: turn, last: last} = history) do
    # if last_spoken in history
    if Enum.count(Map.get(history, last)) > 1 do
      history
      |> say((turn - 1) - last_said(history, last))
      |> next_turn
      |> p1
    else
      history
      |> say(0)
      |> next_turn
      |> p1
    end
  end

  def p2(%{turn: 30000001, last: last}), do: last
  def p2(%{turn: turn, last: last} = history) do
    # if last_spoken in history
    if Enum.count(Map.get(history, last)) > 1 do
      history
      |> say((turn - 1) - last_said(history, last))
      |> next_turn
      |> p2
    else
      history
      |> say(0)
      |> next_turn
      |> p2
    end
  end
end
