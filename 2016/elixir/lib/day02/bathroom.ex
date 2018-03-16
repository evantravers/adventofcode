require IEx

defmodule Advent2016.Day2 do
  @moduledoc """
  http://adventofcode.com/2016/day/2
  """

  def load_instructions(file) do
    with {:ok, file} <- File.read("#{__DIR__}/#{file}"), do: file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  @doc """
  A transposed get function to allow me to use the nested maps.
  """
  def get({x, y}, pad) do
    get_in(pad, [y, x])
  end

  def move({x, y}, "U"), do: {x, y+1}
  def move({x, y}, "D"), do: {x, y-1}
  def move({x, y}, "L"), do: {x-1, y}
  def move({x, y}, "R"), do: {x+1, y}

  def calculate_next_button(state, moves) do
    Enum.reduce(moves, state, fn (char, state) ->
      next_position =
        state.finger
        |> move(char)

      if is_nil(get(next_position, state.pad)) do
        state
      else
        state
        |> Map.put(:finger, next_position)
      end
    end)
  end

  def p1 do
    pad =
      %{0 => %{0 => "1", 1 => "2", 2 => "3"},
        1 => %{0 => "4", 1 => "5", 2 => "6"},
        2 => %{0 => "7", 1 => "8", 2 => "9"}}

    "input.txt"
    |> load_instructions
    |> Enum.reduce(%{pad: pad, finger: {1, 1}}, fn (list_of_moves, state) ->
      IO.inspect list_of_moves
      state
      |> calculate_next_button(list_of_moves)
      |> Map.update(:answer, "", &(&1 <> get(state.finger, state.pad)))
    end)
    |> Map.get(:answer)
  end

  def p2 do
    pad =
      %{
        0 => %{                    2 => "1"},
        1 => %{          1 => "2", 2 => "3", 3 => "4"},
        2 => %{0 => "5", 1 => "6", 2 => "7", 3 => "8", 4 => "9"},
        3 => %{          1 => "A", 2 => "B", 3 => "C"},
        4 => %{                    2 => "D"}
      }
    %{pad: pad, finger: {0, 2}}
  end
end

