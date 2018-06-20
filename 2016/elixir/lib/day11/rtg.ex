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
  """

  defmodule Sim do
    @moduledoc """
    TODO: Optimize the lookup/complement datastructure... probably need a struct
    with a part that holds the position, and a hash that looks up the id of a
    complement... right now `find_complement/2` seems really expensive...

    ## Current thinking:
    - history_tree is a hash of position_ids (possibly using
      `:erlang.unique_integer`) pointing at unique object_configurations
    - object_configurations is a hash of %{position_ids => state_hash}

    This would allow me to generate a "history" of positions for a given
    solution for debugging purposes without storing huge copies of everything.
    """
    defstruct history_tree: %{}, object_configurations: %{}
  end

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

    %{elevator: 0, objects: objects, moves: 0}
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
  def valid_elevator_moves(%{elevator: 1}), do: [2, 0]
  def valid_elevator_moves(%{elevator: 2}), do: [3, 1]
  def valid_elevator_moves(%{elevator: 3}), do: [2]

  @doc """
  We can move one or two things from the current floor to a new floor, either
  up or down.
  """
  def valid_moves(world) do
    movable_objects =
      if Enum.count(floor(world)) > 1 do
        twos = world |> floor |> Combination.combine(2)
        ones = world |> floor |> Combination.combine(1)
        ones ++ twos
      else
        world |> floor |> Combination.combine(1)
      end

    for list_of_obj <- movable_objects,
        new_floor <- valid_elevator_moves(world) do
          Enum.reduce(list_of_obj, world, fn(obj, world) ->
            move_to_floor(world, obj, new_floor)
          end)
    end
    |> Enum.map(fn(world) -> Map.update!(world, :moves, & &1 + 1) end)
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

  def visited?(visited, %{objects: objects}) do
    MapSet.member?(visited, objects)
  end

  def solve(starting_state) when is_map(starting_state) do
    starting_state
    |> List.wrap
    |> solve
  end

  def solve([world|stack], visited \\ MapSet.new) do
    if victory?(world) do
      world
    else
      new_positions =
        world
        |> valid_moves
        |> Enum.reject(&visited?(visited, &1))

      solve(new_positions ++ stack, MapSet.put(visited, world))
    end
  end

  def p1 do
    load_input()
    |> solve
    |> Map.get(:moves)
  end
  def p2, do: nil
end
