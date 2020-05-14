defmodule Advent2019.Day2 do
  @moduledoc "https://adventofcode.com/2019/day/2"
  @behaviour Advent

  def setup do
    Intcode.load_file("#{__DIR__}/input.txt")
  end

  @doc """
  To do this, before running the program, replace position 1 with the value 12
  and replace position 2 with the value 2.
  """
  def p1(env) do
    env
    |> put_in([:tape, 1], 12)
    |> put_in([:tape, 2], 2)
    |> Intcode.start
    |> get_in([:tape, 0])
  end

  @doc """
  Find the input noun and verb that cause the program to produce the output
  19690720. What is 100 * noun + verb? (For example, if noun=12 and verb=2, the
  answer would be 1202.)
  """
  def p2(input) do
    try do
      for noun <- 0..99, verb <- 0..99 do
        result =
          input
          |> put_in([:tape, 1], noun)
          |> put_in([:tape, 2], verb)
          |> Intcode.start
          |> get_in([:tape, 0])

        if result == 19690720 do
          throw({:break, (100 * noun + verb)})
        end
      end
    catch
      {:break, result} -> result
    end
  end
end
