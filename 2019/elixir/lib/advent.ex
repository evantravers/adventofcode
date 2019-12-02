defmodule Advent do
  @moduledoc """
  This is intended to be an importable module that defines some runners and
  conventions for advent of code problems.

  Each "day" should contain the following methods...

  - `setup/0` should setup a input object.
  - `p1/1` and `p2/2` should take the input and solve the puzzle, returning the
    answer.

  I want to define a test runner such that if you run mix <day number> it runs
  `setup/0` once and runs `p1/1` and/or `p2/1` when appropriate.
  """

  @callback setup() :: {:ok, term}
  @callback p1(Map.t) :: {:ok, term}
  @callback p2(Map.t) :: {:ok, term}
end

defmodule Mix.Tasks.Day do
  use Mix.Task

  @shortdoc "Run a specific day from the problem set"
  def run(day) do
    if day == ["all"] do
      {total_time, _} = :timer.tc(fn ->
        Enum.each(1..25, fn d ->
          run d
          IO.puts "\n"
        end)
      end)
      IO.puts("Total Time: #{total_time/1_000_000} seconds")
    else
        input =
          apply(String.to_existing_atom("Elixir.Advent2019.Day#{day}"), :setup, [])

        {p1_time, p1_answer} = :timer.tc(fn ->
          apply(String.to_existing_atom("Elixir.Advent2019.Day#{day}"), :p1, [input])
        end)
        {p2_time, p2_answer} = :timer.tc(fn ->
          apply(String.to_existing_atom("Elixir.Advent2019.Day#{day}"), :p2, [input])
        end)
      IO.puts "Day #{day}: \n" <>
              "Part 1:\n#{p1_answer}\n(#{p1_time/1_000_000} seconds)\n" <>
              "Part 2:\n#{p2_answer}\n(#{p2_time/1_000_000} seconds)"
    end
  end
end
