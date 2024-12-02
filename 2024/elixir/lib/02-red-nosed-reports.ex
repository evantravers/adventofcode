defmodule Advent2024.Day2 do
  @moduledoc "https://adventofcode.com/2024/day/2"

  def setup do
    with {:ok, file} <- File.read("../input/2") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(fn(str) ->
        str
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
    end
  end

  @doc """
  iex> continuous?([1, 2, 3])
  true
  iex> continuous?([3, 2, 1])
  true
  iex> continuous?([2, 3, 1])
  false
  """
  def continuous?(list_of_numbers) do
    cond do
      list_of_numbers == list_of_numbers |> Enum.sort |> Enum.reverse ->
        true
      list_of_numbers == list_of_numbers |> Enum.sort ->
        true
      true ->
        false
    end
  end

  @doc """
  iex> safe_acceleration?([1, 2, 3])
  true
  iex> safe_acceleration?([3, 2, 1])
  true
  iex> safe_acceleration?([1, 5, 31])
  false
  iex> safe_acceleration?([31, 5, 1])
  false
  """
  def safe_acceleration?(list_of_numbers) do
    false !=
      list_of_numbers
      |> Enum.reduce_while(hd(list_of_numbers)-1, fn(num, prev) ->
        difference = abs(num - prev)
        if difference > 0 && difference <= 3 do
          {:cont, num}
        else
          {:halt, false}
        end
      end)
  end

  def safe?(list_of_numbers) do
    continuous?(list_of_numbers) && safe_acceleration?(list_of_numbers)
  end

  def p1(list_of_reports) do
    list_of_reports
    |> Enum.count(&safe?/1)
  end
  def p2(list_of_reports) do
    list_of_reports
    |> Enum.count(fn reports ->
      if safe?(reports) do
        true
      else
        for n <- 0..length(reports) do
          reports
          |> List.delete_at(n)
        end
        |> Enum.any?(&safe?/1)
      end
    end)
  end
end
