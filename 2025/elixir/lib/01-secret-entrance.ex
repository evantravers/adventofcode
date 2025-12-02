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

  def dir({:L, count}), do: -1 * count
  def dir({:R, count}), do: count

  @doc """
  iex> next_position(11, {:R, 8})
  19

  iex> next_position(19, {:L, 19})
  0

  iex> next_position(0, {:L, 1})
  99

  iex> next_position(99, {:R, 1})
  0

  iex> next_position(5, {:L, 10})
  95

  iex> next_position(95, {:R, 5})
  0
  """
  def next_position(pointer, instruction) do
    Integer.mod(pointer - dir(instruction), 100)
  end

  def calc_position(instruction, [pointer|_rest] = locs) do
    [next_position(pointer, instruction)|locs]
  end

  def click(instruction, {last_pos, sign_swap_count}) do
    steps     = last_pos + dir(instruction)
    rotations = abs(Integer.floor_div(steps, 100))

    {Integer.mod(steps, 100), sign_swap_count + rotations}
  end

  @doc """
  Count how many times that the dial ends on 0.
  """
  def p1(instructions) do
    start = [50]

    instructions
    |> Enum.reduce(start, &calc_position/2)
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
    {_last_pos, count} = Enum.reduce(instructions, start, &click/2)

    count
  end
end
