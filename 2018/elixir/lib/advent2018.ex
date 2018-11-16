defmodule Advent2018 do
  @moduledoc """
  My work for Advent of Code 2018 in elixir this year!

  I started out writing it in random .exs scripts, but now I'm putting it into
  mix so I can use tests.
  """
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
        {p1_time, p1_answer} = :timer.tc(fn ->
          apply(String.to_existing_atom("Elixir.Advent2018.Day#{day}"), :p1, [])
        end)
        {p2_time, p2_answer} = :timer.tc(fn ->
          apply(String.to_existing_atom("Elixir.Advent2018.Day#{day}"), :p2, [])
        end)
      IO.puts "Day #{day}: \n" <>
              "Part 1:\n#{p1_answer}\n(#{p1_time/1_000_000} seconds)\n" <>
              "Part 2:\n#{p2_answer}\n(#{p2_time/1_000_000} seconds)"
    end
  end
end
