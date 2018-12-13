defmodule Advent2018.Day10 do
  @moduledoc "https://adventofcode.com/2018/day/10"

  def load_input(input \\ "input.txt") do
    with {:ok, file} <- File.read("#{__DIR__}/#{input}") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&read_line/1)
    end
  end

  def read_line(str) do
    [x, y, vx, vy] =
      ~r/-*\d+/
      |> Regex.scan(str)
      |> List.flatten
      |> Enum.map(&String.to_integer/1)

    %{position: {x, y}, velocity: {vx, vy}}
  end

  def move(%{position: {x, y}, velocity: {vx, vy}} = object) do
    %{object | position: {x + vx, y + vy}}
  end

  def p1 do
    load_input()
  end

  def p2, do: nil
end
