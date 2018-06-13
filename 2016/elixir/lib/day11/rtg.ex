defmodule Advent2016.Day11 do
  @moduledoc """
  http://adventofcode.com/2016/day/11

  Part 1:
  In your situation, what is the minimum number of steps required to bring all
  of the objects to the fourth floor?

  Part 2:
  What is the minimum number of steps required to bring all of the objects,
  including these four new ones, to the fourth floor?
  """

  def load_input(file \\ "input") do
    with {:ok, file} <- File.read("#{__DIR__}/#{file}") do
      file
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.reduce([], fn({string, number}, world) ->
        build_floor(world, string, number)
      end)
    end
  end

  def build_floor(world, string, number) do
    ~r/(?:\w+(?: generator|-compatible microchip))/
    |> Regex.scan(string)
    |> List.flatten
    |> Enum.map(fn(object) ->
      object
      |> identify_object
      |> Map.put(:floor, number)
    end)
    |> List.wrap
    |> Kernel.++(world)
  end

  @doc """
      iex> identify_object("cobalt-compatible microchip")
      %{element: :cobalt, type: :microchip}
  """
  def identify_object(string) do
    [element, type] =
      string
      |> String.split(" ")

    %{element: clean_name(element), type: String.to_atom(type)}
  end

  @doc """
      iex> clean_name("cobalt")
      :cobalt
      iex> clean_name("cobalt-compatible")
      :cobalt
  """
  def clean_name(element) do
    element
    |> String.replace("-compatible", "")
    |> String.to_atom
  end

  def p1, do: nil
  def p2, do: nil
end
