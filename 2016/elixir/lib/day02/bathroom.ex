defmodule Advent2016.Day2 do
  @moduledoc """
  http://adventofcode.com/2016/day/2
  """

  def load_instructions(file) do
    with {:ok, file} <- File.read("#{__DIR__}/#{file}"), do: file
    |> String.replace("\n", "")
    |> String.split("", trim: true)
  end

  @doc ~S"""
      iex> execute("test.txt")
      "1985"
  """
  def p1 do
    keypad =
      %{0 => %{0 => "1", 1 => "2", 2 => "3"},
        1 => %{0 => "4", 1 => "5", 2 => "6"},
        2 => %{0 => "7", 1 => "8", 2 => "9"}}
  end
  def p2 do
    keypad =
      %{
        0 => %{                    2 => "1"},
        1 => %{          1 => "2", 2 => "3", 3 => "4"}
        2 => %{0 => "5", 1 => "6", 2 => "7", 3 => "8", 4 => "9"}
        3 => %{          1 => "A", 2 => "B", 3 => "C"}
        4 => %{                    2 => "D"}
      }
  end
end

