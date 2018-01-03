defmodule Advent2015.Day2 do
  @moduledoc """
  Fortunately, every present is a box (a perfect right rectangular prism),
  which makes calculating the required wrapping paper for each gift a little
  easier: find the surface area of the box, which is 2*l*w + 2*w*h + 2*h*l. The
  elves also need a little extra paper for each present: the area of the
  smallest side.
  """

  def load_input do
    {:ok, file} = File.read("#{__DIR__}/input.txt")

    file
    |> String.split("\n", trim: true)
    |> Enum.map(fn str ->
      str
      |> String.split("x")
      |> Enum.map(&String.to_integer &1)
    end)
  end

  @doc ~S"""
      iex> Advent2015.Day2.surface_area([2,3,4])
      58
  """
  def surface_area([l, w, h]) do
    [s1, s2] = smallest_face([l, w, h])
    2 * l * w + 2 * w * h + 2 * h * l + s1 * s2
  end

  def smallest_face(list) do
    [s1, s2, _] = Enum.sort list
    [s1, s2]
  end

  @doc ~S"""
      iex> Advent2015.Day2.volume([2, 3, 4])
      24
  """
  def volume(p) do
    Enum.reduce(p, & &1 * &2)
  end

  @doc ~S"""
      iex> Advent2015.Day2.ribbon_length([2, 3, 4])
      34
  """
  def ribbon_length(package) do
    volume(package) + Enum.reduce(smallest_face(package), 0, & &1 + &2) * 2
  end

  def p1 do
    load_input()
    |> Enum.reduce(0, fn package, sum -> sum + surface_area(package) end)
  end

  def p2 do
    load_input()
    |> Enum.reduce(0, fn package, sum -> sum + ribbon_length(package) end)
  end
end
