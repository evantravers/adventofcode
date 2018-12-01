defmodule Advent2018.Day1 do
  @moduledoc """
  """

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end
  end

  def find_first_repeated(stream_of_shifts) do
    stream_of_shifts
    |> Enum.reduce_while({0, MapSet.new()}, fn(num, {sum, history}) ->
      if MapSet.member?(history, sum) do
        {:halt, sum}
      else
        {:cont, {sum + num, MapSet.put(history, sum)}}
      end
    end)
  end

  @doc """
  Starting with a frequency of zero, what is the resulting frequency after all
  of the changes in frequency have been applied?
  """
  def p1 do
    load_input
    |> Enum.sum
  end

  @doc """
  """
  def p2 do
    load_input
    |> Stream.cycle
    |> find_first_repeated
  end
end
