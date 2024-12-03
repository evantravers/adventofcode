defmodule Advent2024.Day3 do
  @moduledoc "https://adventofcode.com/2024/day/3"

  def setup do
    with {:ok, file} <- File.read("../input/3") do
      file
      |> String.split("\n", trim: true)
    end
  end

  @doc """
  iex> process_multiples("xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))")
  161
  """
  def process_multiples(str) do
    instructions = Regex.scan(~r/mul\(\d+,\d+\)/, str)
    if is_list(instructions) do
      numbers =
        ~r/\d+/
        |> Regex.scan(Enum.join(instructions))
        |> List.flatten

      numbers
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn([a, b]) -> a * b end)
      |> Enum.sum
    end
  end

  def p1(list_of_strings) do
    list_of_strings
    |> Enum.map(&process_multiples/1)
    |> Enum.sum
  end
  def p2(_i), do: nil
end
