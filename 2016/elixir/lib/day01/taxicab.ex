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
  def turn(state = %{compass: "W"}, "R"), do: %{state | compass: "S"}
  def turn(state = %{compass: "S"}, "R"), do: %{state | compass: "W"}
  def turn(state = %{compass: "E"}, "R"), do: %{state | compass: "N"}

  def step, do: nil

  def walk(state) do
    # take an instruction
    [direction, distance] = state.instructions
                            |> hd
                            |> String.split("", trim: true)
    # turn the direction that we need to go
    # recursively step that direction
  end

  def p1 do
    %{compass: "N", visited: [{0, 0}], instructions: load_instructions()}
    |> walk
  end

  def p2, do: nil
end
