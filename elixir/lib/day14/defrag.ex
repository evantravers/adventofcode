defmodule Advent2017.Day14 do
  alias Advent2017.Day10, as: Knot

  @doc ~S"""
      iex> Advent2017.Day14.hex_to_bin("a0c2017")
      "10100000110000100000000101110000"
  """
  def hex_to_bin(str) do
    str
    |> String.to_integer(16)
    |> Integer.to_string(2)
  end

  def defrag(input) do
    Enum.map(0..127, fn row ->
      Knot.dense_hash("#{input}-#{row}")
      |> hex_to_bin
      |> String.split("", [trim: true])
      |> Enum.map(&String.to_integer &1)
    end)
  end

  def p1 do
    defrag("ljoxqyyw")
    |> List.flatten
    |> Enum.sum
  end
  def p2, do: nil
end
