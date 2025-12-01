defmodule Advent2025.Day1 do
  @moduledoc "https://adventofcode.com/2025/day/1"

  def setup do
    with {:ok, file} <- File.read("../input/01") do
      file
      |> setup_from_string
    end
  end

  def setup_from_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&translate_instructions/1)
  end

  def translate_instructions("L" <> count), do: {:L, String.to_integer(count)}
  def translate_instructions("R" <> count), do: {:R, String.to_integer(count)}

  @doc """
  iex> calc_position(11, {:R, 8})
  19

  iex> calc_position(19, {:L, 19})
  0

  iex> calc_position(0, {:L, 1})
  99

  iex> calc_position(99, {:R, 1})
  0

  iex> calc_position(5, {:L, 10})
  95

  iex> calc_position(95, {:R, 5})
  0
  """
  def calc_position(pointer, {:L, count}), do: Integer.mod(pointer - count, 100)
  def calc_position(pointer, {:R, count}), do: Integer.mod(pointer + count, 100)

  def next(instruction, [pointer|_rest] = locs) do
    [calc_position(pointer, instruction)|locs]
  end

  def track({:L, count}, {last_pos, sign_swap_count}) do
    steps         = last_pos - count
    rotations     = abs(Integer.floor_div(steps, 100))

    {Integer.mod(steps, 100), sign_swap_count + rotations}
  end
  def track({:R, count}, {last_pos, sign_swap_count}) do
    steps         = last_pos + count
    rotations     = abs(Integer.floor_div(steps, 100))

    {Integer.mod(steps, 100), sign_swap_count + rotations}
  end

  @doc """
  Count how many times that the dial ends on 0.
  """
  def p1(instructions) do
    start = [50]

    instructions
    |> Enum.reduce(start, &next/2)
    |> Enum.count(& &1 == 0)
  end

  @doc """
  Count how many times the dial _passes_ 0.

  We are going to just keep track of sign changes.

  iex> "L68
  ...>L30
  ...>R48
  ...>L5
  ...>R60
  ...>L55
  ...>L1
  ...>L99
  ...>R14
  ...>L82"
  ...> |> setup_from_string
  ...> |> p2
  6

  iex> "R1000"
  ...> |> setup_from_string
  ...> |> p2
  10

  iex> "R1050"
  ...> |> setup_from_string
  ...> |> p2
  11
  """
  def p2(instructions) do
    start = {50, 0} # {last_position, sign_swap_count}

    {_last_pos, count} = Enum.reduce(instructions, start, &track/2)

    count
  end
end
