defmodule Advent2016.Day8 do
  @moduledoc """
  http://adventofcode.com/2016/day/8
  """

  def rect(screen, [x, y]) do
    for x <- 0..x-1 do
      for y <- 0..y-1 do
        {x, y}
      end
    end
    |> List.flatten
    |> Kernel.++(screen)
    |> Enum.uniq # You could make a rectangle *over* existing "on" lights
  end

  def rotate(screen, :row, [y, offset]) do
    {row, remainder} =
      screen
      |> Enum.split_with(fn({_, target}) -> target == y end)

    row
    |> Enum.map(fn({x, y}) -> {rem(x + offset, 50), y} end)
    |> Kernel.++(remainder)
  end

  def rotate(screen, :column, [x, offset]) do
    {column, remainder} =
      screen
      |> Enum.split_with(fn({target, _}) -> target == x end)

    column
    |> Enum.map(fn({x, y}) -> {x, rem(y + offset, 6)} end)
    |> Kernel.++(remainder)
  end

  def print(screen) do
    {max_x, _} = Enum.max_by(screen, fn({x, _}) -> x end)
    {_, max_y} = Enum.max_by(screen, fn({_, y}) -> y end)

    for y <- 0..max_y do
      for x <- 0..max_x do
        case Enum.member?(screen, {x, y}) do
           true -> "#"
          false -> " "
        end
      end
      |> Enum.join
      |> Kernel.<>("\n")
    end
    |> Enum.join
  end

  def test do
    []
    |> rect([3, 2])
    |> rotate(:column, [1, 1])
    |> rotate(:row, [0, 4])
    |> rotate(:column, [1, 1])
  end

  def load_instructions do
    with {:ok, file} <- File.read("#{__DIR__}/input"), do: file
    |> String.split("\n", trim: true)
  end

  def execute(screen, instruction) do
    case instruction do
      "rect" <> args ->
        rect(screen, extract_args(args))
      "rotate row" <> args ->
        rotate(screen, :row, extract_args(args))
      "rotate column" <> args ->
        rotate(screen, :column, extract_args(args))
    end
  end

  def extract_args(string) do
    ~r/\d+/
    |> Regex.scan(string)
    |> List.flatten
    |> Enum.map(&String.to_integer/1)
  end

  def run do
    load_instructions()
    |> Enum.reduce([], fn(instruction, screen) ->
      execute(screen, instruction)
    end)
  end

  def p1, do: run |> Enum.count
  def p2, do: run |> print
end
