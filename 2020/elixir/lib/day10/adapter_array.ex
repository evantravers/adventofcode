defmodule Advent2020.Day10 do
  @moduledoc "https://adventofcode.com/2020/day/10"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_adapter/1)
    end
  end

  def parse_adapter(str) do
    num = String.to_integer(str)
    %{output: num, input: (num - 3)..num}
  end

  def p1(adapters) do
    outlet = %{output: 0}

    device_adapter_joltage =
      adapters
      |> Enum.map(&Map.get(&1, :output))
      |> Enum.max
      |> Kernel.+(3)

    device = %{input: device_adapter_joltage}
  end

  def p2(_i), do: nil
end
