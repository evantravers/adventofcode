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

  def floor(world) when is_map(world), do: floor(world.objects, world.elevator)

  def floor(objects, floor_num) do
    objects |> Enum.filter(& &1.floor == floor_num)
  end

  def valid_elevator_moves(%{elevator: 0}), do: [1]
  def valid_elevator_moves(%{elevator: 1}), do: [0, 2]
  def valid_elevator_moves(%{elevator: 2}), do: [1, 3]
  def valid_elevator_moves(%{elevator: 3}), do: [2]

  @doc """
  We can move one or two things from the current floor to a new floor, either
  up or down.

  FIXME: This isn't finished yet... it's not moving both for some reason, and
  it's returning duplicate options?
  """
  def valid_moves(world) do
    with twos <- world |> floor |> Combination.combine(2),
         ones <- world |> floor |> Combination.combine(1)
    do
      movable_objects = ones ++ twos

      for list_of_obj <- movable_objects,
          new_floor <- valid_elevator_moves(world) do
        list_of_obj
        |> Enum.map(& move_to_floor(world, &1, new_floor))
      end
    end
    |> List.flatten
  end

  @doc """
  Very obtuse, probably because my data sttructure stinks
  """
  def move_to_floor(world, object, floor) do
    world
    |> Map.update!(:objects, fn(objects) ->
      [%{object|floor: floor} | objects] |> List.delete(object)
    end)
    |> Map.put(:elevator, floor)
  end

  def victory?(%{objects: objects}) do
    Enum.all?(objects, fn(obj) -> obj.floor == 3 end)
  end

  def solve(input) when is_binary(input) do
    input
    |> load_input
    |> solve
  end

  def solve(world, visited \\ MapSet.new, moves \\ 0) when is_map(world) do
    # FIXME this will keep going nearly infinitely, it won't break when it
    # finds the solution. I need to implement a system that doesn't really
    # recurse... maybe use a queue? Otherwise, I need to find a way to send a
    # message when it's done perhaps.
    if victory?(world) do
      {world, moves}
    else
      world
      |> valid_moves
      |> MapSet.difference(visited)
      |> Enum.map(& solve(&1, MapSet.put(world), moves + 1))
    end
  end

  def p1, do: nil
  def p2, do: nil
end
