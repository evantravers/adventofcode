defmodule Advent2016.Day2 do
  @moduledoc """
  http://adventofcode.com/2016/day/2
  """

  def load_instructions(file) do
    with {:ok, file} <- File.read("#{__DIR__}/#{file}"), do: file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  @doc """
  A transposed get function to allow me to use the nested maps.
  """
  def button_at(pad, {x, y}) do
    get_in(pad, [y, x])
  end

  def move({x, y}, "U"), do: {x, y+1}
  def move({x, y}, "D"), do: {x, y-1}
  def move({x, y}, "L"), do: {x-1, y}
  def move({x, y}, "R"), do: {x+1, y}

  def p1 do
    keypad =
      %{0 => %{0 => "1", 1 => "2", 2 => "3"},
        1 => %{0 => "4", 1 => "5", 2 => "6"},
        2 => %{0 => "7", 1 => "8", 2 => "9"}}

    instructions = load_instructions("input.txt")

    state = %{keypad: keypad, finger: {1, 1}}
  end

  def p2 do
    keypad =
      %{
        0 => %{                    2 => "1"},
        1 => %{          1 => "2", 2 => "3", 3 => "4"},
        2 => %{0 => "5", 1 => "6", 2 => "7", 3 => "8", 4 => "9"},
        3 => %{          1 => "A", 2 => "B", 3 => "C"},
        4 => %{                    2 => "D"}
      }

    instructions = load_instructions("input.txt")

    state = %{keypad: keypad, finger: {0, 2}}
  end
end

