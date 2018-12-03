defmodule Advent2018.Day2 do
  @moduledoc """
  Not my best work, but it works.
  """

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
    end
  end

  def count_chars(string) do
    string
    |> String.graphemes
    |> Enum.reduce(%{}, fn(char, count) ->
      Map.update(count, char, 1, & &1 + 1)
    end)
  end

  def find_checksum(list_of_maps, target) do
    list_of_maps
    |> Enum.map(&Map.values/1)
    |> Enum.filter(&Enum.member?(&1, target))
    |> Enum.count
  end

  def find_box(list_of_graphemes, graphemes) do
    list_of_graphemes
    |> Enum.find(fn(str) ->
      1 ==
        graphemes
        |> MapSet.difference(str)
        |> MapSet.size
    end)
  end

  @doc """
  Now that I've found the two boxes, time to throw away their different
  character and return a result.
  """
  def find_solution(strings, result \\ "")
  def find_solution([[], []], result), do: result
  def find_solution([[{char1, _}|tail1], [{char2, _}|tail2]], result) do
    if char1 == char2 do
      find_solution([tail1, tail2], result <> char1)
    else
      find_solution([tail1, tail2], result)
    end
  end

  def p1 do
    checksums = load_input() |> Enum.map(&count_chars/1)

    find_checksum(checksums, 3) * find_checksum(checksums, 2)
  end

  def p2 do
    search =
      load_input()
      |> Enum.sort # should guarantee that at least the winning case will be adj.
      |> Enum.map(fn(str) ->
        str
        |> String.graphemes
        |> Enum.with_index
        |> MapSet.new
      end)

    search
    |> Enum.map(&find_box(search, &1))
    |> Enum.reject(&is_nil/1)
    |> Enum.map(fn(str) -> str |> Enum.to_list |> List.keysort(1) end)
    |> find_solution
  end
end
