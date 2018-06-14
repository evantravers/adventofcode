defmodule Advent2016.Day11 do
  @moduledoc """
  http://adventofcode.com/2016/day/11

  In other words, if a chip is ever left in the same area as another RTG, and
  it's not connected to its own RTG, the chip will be fried. Therefore, it is
  assumed that you will follow procedure and keep chips connected to their
  corresponding RTG when they're in the same room, and away from other RTGs
  otherwise.

  The elevator can move up to two things at once, but must stop on every floor.

  Part 1:
  In your situation, what is the minimum number of steps required to bring all
  of the objects to the fourth floor?

  Part 2:
  What is the minimum number of steps required to bring all of the objects,
  including these four new ones, to the fourth floor?

  TODO: from a state, generate possible `valid?` states
  """

  def load_input(file \\ "input") do
    objects =
      with {:ok, file} <- File.read("#{__DIR__}/#{file}") do
        file
        |> String.split("\n", trim: true)
        |> Enum.with_index
        |> Enum.reduce([], fn({string, number}, world) ->
          build_floor(world, string, number)
        end)
      end

    %{elevator: 0, objects: objects}
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

  @doc """
  A state is invalid if there's an unshielded chip on the same floor as an
  unshielded generator.

      iex> load_input("test") |> valid?
      true
      iex> load_input("fail") |> valid?
      false
  """
  def valid?(%{objects: objects}) do
    objects
    |> Enum.filter(& &1.type == :microchip)
    |> Enum.any?(fn(chip) ->
      objects
      |> floor(chip.floor)
      |> Enum.filter(& &1.type == :generator)
      |> Enum.any?(&!shielded?(objects, &1))
    end)
    |> Kernel.!
  end

  def complement_type(:generator), do: :microchip
  def complement_type(:microchip), do: :generator

  def find_complement(objects, object) do
    objects
    |> Enum.find(fn(target) ->
      target.element == object.element
      &&
      target.type    == complement_type(object.type)
    end)
  end

  def shielded?(objects, object) do
    find_complement(objects, object).floor == object.floor
  end

  def floor(objects, floor_num) do
    objects |> Enum.filter(& &1.floor == floor_num)
  end

  def p1, do: nil
  def p2, do: nil
end
