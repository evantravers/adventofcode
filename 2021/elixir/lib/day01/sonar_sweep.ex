defmodule Advent2021.Day1 do
  @moduledoc "https://adventofcode.com/2021/day/1"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt"), do: setup_string(file)
  end

  def setup_string(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
      iex> "199
      ...>200
      ...>208
      ...>210
      ...>200
      ...>207
      ...>240
      ...>269
      ...>260
      ...>263"
      ...> |> setup_string
      ...> |> p1
      7
  """
  def p1(list, previous \\ 0, count \\ -1)
  def p1([], _previous, count), do: count
  def p1([current|rest], previous, count) do
    if current > previous do
      p1(rest, current, count + 1)
    else
      p1(rest, current, count)
    end
  end

  def p2(list) do
    list
    |> Enum.chunk_every(3, 1)
    |> Enum.map(&Enum.sum/1)
    |> p1
  end
end
