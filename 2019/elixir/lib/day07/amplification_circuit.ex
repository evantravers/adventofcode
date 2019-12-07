defmodule Advent2019.Day7 do
  @moduledoc "https://adventofcode.com/2019/day/7"
  @behaviour Advent

  def setup do
    string = "#{__DIR__}/input.txt"

    [Intcode.load_file(string),
      Intcode.load_file(string),
      Intcode.load_file(string),
      Intcode.load_file(string),
      Intcode.load_file(string)]
  end

  def provide_input(computer = %{input: input}, phase_setting, previous_output) do
    %{computer | input: [phase_setting | [previous_output | input]]}
  end

  # https://elixirforum.com/t/most-elegant-way-to-generate-all-permutations/2706
  def permutations([]), do: [[]]
  def permutations(list) do
    for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]
  end

  def p1(list_of_amps) do
    for phase_settings <- permutations([0, 1, 2, 3, 4]) do
      {
        list_of_amps
        |> Enum.zip(phase_settings)
        |> Enum.reduce(0, fn({amp, phase_setting}, previous_output) ->
          provide_input(amp, phase_setting, previous_output)
          |> Intcode.run
          |> Map.get(:output)
          |> hd
        end),
        phase_settings
      }
    end
    |> Enum.max_by(&elem(&1, 0))
    |> elem(1)
    |> Enum.join
  end

  def p2(_) do
  end
end
