defmodule Advent2019.Day9 do
  @moduledoc "https://adventofcode.com/2019/day/9"
  @behaviour Advent

  def setup do
    Intcode.load_file("#{__DIR__}/input.txt")
  end

  @doc ~S"""
      iex> "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"
      ...> |> Intcode.load
      ...> |> p1
      "109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99"

      iex> "1102,34915192,34915192,7,4,7,99,0"
      ...> |> Intcode.load
      ...> |> p1
      ...> |> String.length
      16

      iex> "104,1125899906842624,99"
      ...> |> Intcode.load
      ...> |> p1
      "1125899906842624"
  """
  def p1(machine) do
    machine
    |> Intcode.put_input(1)
    |> Intcode.run
    |> Map.get(:output)
    |> Enum.reverse
    |> Enum.join(",")
  end

  def p2(i) do
    "not complete"
  end
end
