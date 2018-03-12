defmodule Advent2016.Day1 do
  @moduledoc """
  http://adventofcode.com/2016/day/1
  """

  def load_instructions(input \\ "input") do
    {:ok, file} = File.read("#{__DIR__}/#{input}")

    String.split(file, ", ", trim: true)
  end

  def turn(state = %{compass: "N"}, "L"), do: %{state | compass: "W"}
  def turn(state = %{compass: "W"}, "L"), do: %{state | compass: "S"}
  def turn(state = %{compass: "S"}, "L"), do: %{state | compass: "E"}
  def turn(state = %{compass: "E"}, "L"), do: %{state | compass: "N"}

  def turn(state = %{compass: "N"}, "R"), do: %{state | compass: "E"}
  def turn(state = %{compass: "E"}, "R"), do: %{state | compass: "S"}
  def turn(state = %{compass: "S"}, "R"), do: %{state | compass: "W"}
  def turn(state = %{compass: "W"}, "R"), do: %{state | compass: "N"}

  def step(state, 0), do: state
  def step(state, distance) do
    {x, y} = hd(state.visited)

    next_position =
      case state.compass do
        "N" -> {x, y + 1}
        "E" -> {x + 1, y}
        "S" -> {x, y - 1}
        "W" -> {x - 1, y}
      end

    %{state | visited: [next_position | state.visited]}
    |> step(distance - 1)
  end

  def calc_distance(pos) do
    pos
    |> Tuple.to_list
    |> Enum.map(&abs &1)
    |> Enum.sum
  end

  def walk(state, instructions)
  def walk(state, []), do: state
  def walk(state, [instruction|instructions]) do
    # take an instruction
    [_, direction, distance] = Regex.run(~r/([L|R])(.*)/, instruction)

    distance = String.to_integer(distance)

    state
    |> turn(direction)
    |> step(distance)
    |> walk(instructions)
  end

  def p1 do
    %{compass: "N", visited: [{0, 0}]}
    |> walk(load_instructions())
    |> Map.get(:visited)
    |> List.first
    |> calc_distance
  end

  def p2 do
    %{compass: "N", visited: [{0, 0}]}
    |> walk(load_instructions())
    |> Map.get(:visited)
    |> Enum.reverse
    |> Enum.reduce_while([], fn (element, seen) ->
      if Enum.member?(seen, element) do
        {:halt, element}
      else
        {:cont, [element|seen]}
      end
    end)
    |> calc_distance
  end
end
