defmodule Advent2020.Day12 do
  @moduledoc "https://adventofcode.com/2020/day/12"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&clean/1)
    end
  end

  def clean(string) do
    code =
      string
      |> String.first
      |> String.to_atom
    num =
      string
      |> String.slice(1..String.length(string))
      |> String.to_integer

    { code, num }
  end

  def ship_reads_instruction() do
  end

  def p1(instructions) do
    instructions
  end

  def p2(_state), do: nil
end
