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
  @callback p1(term) :: {:ok, term}
  @callback p2(term) :: {:ok, term}
end

defmodule Mix.Tasks.Day do
  use Mix.Task

  defp timestring(t), do: "#{t/1_000_000} seconds"

  @shortdoc "Run a specific day from the problem set"
  def run(day) do
    if day == ["all"] do
      {total_time, _} = :timer.tc(fn ->
        Enum.each(1..25, fn d ->
          try do
            run d
            IO.puts "\n"
          rescue
            ArgumentError -> "That's all folks!"
          end
        end)
      end)
        IO.puts("""
          ============================
          Total Time: #{timestring(total_time)}
          """)
    else
      {total_time, _} = :timer.tc(fn ->
        input =
          apply(String.to_existing_atom("Elixir.Advent2020.Day#{day}"), :setup, [])

        {p1_time, p1_answer} = :timer.tc(fn ->
          apply(String.to_existing_atom("Elixir.Advent2020.Day#{day}"), :p1, [input])
        end)

        {p2_time, p2_answer} = :timer.tc(fn ->
          apply(String.to_existing_atom("Elixir.Advent2020.Day#{day}"), :p2, [input])
        end)

        IO.puts(
          """
          Day #{day}:
          ----------------------------
          Part 1:
          #{p1_answer}
          (#{timestring(p1_time)})

          Part 2:
          #{p2_answer}
          (#{timestring(p2_time)})
          ----------------------------
          """
        )

      end)
      IO.puts timestring(total_time)
    end
  end
end
