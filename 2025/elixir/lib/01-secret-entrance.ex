defmodule Advent2025.Day1 do
  @moduledoc "https://adventofcode.com/2025/day/1"

  def setup do
    with {:ok, file} <- File.read("../input/01") do
      file
      |> setup_from_string
    end
  end

  def read_instructions("L" <> count), do: {:L, String.to_integer(count)}
  def read_instructions("R" <> count), do: {:R, String.to_integer(count)}
  def setup_from_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&translate_instructions/1)
  end


  def turn({:L, count}, [pointer|_rest] = locs) do
    [Integer.mod(pointer - count, 100)|locs]
  end
  def turn({:R, count}, [pointer|_rest] = locs) do
    [Integer.mod(pointer + count, 100)|locs]
  end

  def p1(instructions) do
    start = [50]

    instructions
    |> Enum.reduce(start, &turn/2)
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
  3
  """
  def p2(instructions) do
    start = {50, 0} # {last_position, sign_swap_count}

    {_last_pos, count} = Enum.reduce(instructions, start, &track/2)

    count
  end
end
