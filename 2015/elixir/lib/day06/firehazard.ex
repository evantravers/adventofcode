defmodule Advent2015.Day6 do
  @moduledoc """
  Lights in your grid are numbered from 0 to 999 in each direction; the lights
  at each corner are at 0,0, 0,999, 999,999, and 999,0. The instructions
  include whether to turn on, turn off, or toggle various inclusive ranges
  given as coordinate pairs. Each coordinate pair represents opposite corners
  of a rectangle, inclusive; a coordinate pair like 0,0 through 2,2 therefore
  refers to 9 lights in a 3x3 square. The lights all start turned off.

  To defeat your neighbors this year, all you have to do is set up your lights
  by doing the instructions Santa sent you in order.

  For example:

  turn on 0,0 through 999,999 would turn on (or leave on) every light.  toggle
  0,0 through 999,0 would toggle the first line of 1000 lights, turning off the
  ones that were on, and turning on the ones that were off.  turn off 499,499
  through 500,500 would turn off (or leave off) the middle four lights.
  """

  @instruction ~r/(toggle|on|off) (\d+),(\d+) through (\d+),(\d+)/

  def load_input() do
    {:ok, file} = File.read("#{__DIR__}/input.txt")

    file
    |> String.split("\n", trim: true)
    |> Enum.map(&Regex.run(@instruction, &1))
    |> Enum.map(fn [_, i, x1, y1, x2, y2] ->
      [String.to_atom(i),
       String.to_integer(x1),
       String.to_integer(y1),
       String.to_integer(x2),
       String.to_integer(y2)]
    end)
  end

  def toggle({:p1, grid}, x1, y1, x2, y2) do
    changed =
      for x <- x1..x2, y <- y1..y2, into: %{} do
        {[x, y], !Map.get(grid, [x, y])}
      end

    Map.merge(grid, changed)
  end

  def toggle({:p2, grid}, x1, y1, x2, y2) do
    changed =
      for x <- x1..x2, y <- y1..y2, into: %{} do
        {[x, y], (fn [x, y] -> Map.get(grid, [x, y]) end).([x, y]) + 2}
      end

    Map.merge(grid, changed)
  end

  def on({:p1, grid}, x1, y1, x2, y2) do
    changed =
      for x <- x1..x2, y <- y1..y2, into: %{} do
        {[x, y], true}
      end

    Map.merge(grid, changed)
  end

  def on({:p2, grid}, x1, y1, x2, y2) do
    changed =
      for x <- x1..x2, y <- y1..y2, into: %{} do
        {[x, y], Map.get(grid, [x, y]) + 1}
      end

    Map.merge(grid, changed)
  end

  def off({:p1, grid}, x1, y1, x2, y2) do
    changed =
      for x <- x1..x2, y <- y1..y2, into: %{} do
        {[x, y], false}
      end

    Map.merge(grid, changed)
  end

  def off({:p2, grid}, x1, y1, x2, y2) do
    changed =
      for x <- x1..x2, y <- y1..y2, into: %{} do
        val = Map.get(grid, [x, y])

        if val == 0 do
          {[x, y], 0}
        else
          {[x, y], val - 1}
        end
      end

    Map.merge(grid, changed)
  end

  def command(grid, [command, x1, y1, x2, y2], problem) do
    apply(Advent2015.Day6, command, [{problem, grid}, x1, y1, x2, y2])
  end

  def p1 do
    grid =
      for x <- 0..999, y <- 0..999, into: %{}, do: {[x, y], false}

    load_input()
    |> Enum.reduce(grid, fn instruction, g ->
      command(g, instruction, :p1)
    end)
    |> Map.to_list
    |> Enum.filter(fn {_, onoroff} -> onoroff end)
    |> Enum.count
  end

  def p2 do
    grid =
      for x <- 0..999, y <- 0..999, into: %{}, do: {[x, y], 0}

    load_input()
    |> Enum.reduce(grid, fn instruction, g ->
      command(g, instruction, :p2)
    end)
    |> Map.to_list
    |> Enum.map(fn {_, val} -> val end)
    |> Enum.sum
  end
end
