defmodule Advent2016 do
  @moduledoc """
  My work for Advent of Code 2016 in elixir.
  """
end

defmodule Mix.Tasks.Day do
  use Mix.Task

  @shortdoc "Run a specific day from the problem set"
  def run(day) do
    if day == ["all"] do
      Enum.each(1..25, fn d ->
        run d
        IO.puts "\n"
      end)
    else
        {p1_time, p1_answer} = :timer.tc(fn ->
          apply(String.to_existing_atom("Elixir.Advent2016.Day#{day}"), :p1, [])
        end)
        {p2_time, p2_answer} = :timer.tc(fn ->
          apply(String.to_existing_atom("Elixir.Advent2016.Day#{day}"), :p2, [])
        end)
      IO.puts "Day #{day}: \n" <>
              "Part 1:\n#{p1_answer}\n(#{p1_time/1_000_000} seconds)\n" <>
              "Part 2:\n#{p2_answer}\n(#{p2_time/1_000_000} seconds)"
    end
  end
end
