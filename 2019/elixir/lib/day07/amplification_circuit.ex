defmodule Advent2019.Day7 do
  @moduledoc "https://adventofcode.com/2019/day/7"
  @behaviour Advent

  def setup do
    with {:ok, intcode_string} <- File.read("#{__DIR__}/input.txt") do
      intcode_string
    end
  end

  # https://elixirforum.com/t/most-elegant-way-to-generate-all-permutations/2706
  def permutations([]), do: [[]]
  def permutations(list) do
    for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]
  end

  @doc """
  P1
      iex> p1("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0", debug: true)
      {43210, [4,3,2,1,0]}

      iex> p1("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0", debug: true)
      {54321, [0,1,2,3,4]}

      iex> p1("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0", debug: true)
      {65210, [1,0,4,3,2]}
  """
  def p1(intcode_string, opts \\ []) do
    for phase_settings <- permutations([0, 1, 2, 3, 4]) do
      {
        [
          Intcode.load(intcode_string),
          Intcode.load(intcode_string),
          Intcode.load(intcode_string),
          Intcode.load(intcode_string),
          Intcode.load(intcode_string)
        ]
        |> Enum.zip(phase_settings)
        |> Enum.reduce(0, fn({amp, phase_setting}, previous_output) ->
          amp
          |> Intcode.put_input(phase_setting)
          |> Intcode.put_input(previous_output)
          |> Intcode.run
          |> Intcode.get_output
        end),
        phase_settings
      }
    end
    |> Enum.max_by(&elem(&1, 0))
    |> (fn({answer, phase_setting}) ->
      if opts[:debug] do
        {answer, phase_setting}
      else
        answer
      end
    end).()
  end

  @doc """
  P2
      iex> p2("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5", debug: true)
      {139629729, [9,8,7,6,5]}

      iex> p2("3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10", debug: true)
      {18216, [9,7,8,5,6]}
  """
  def p2(intcode_string) do
    {:ok, a} = GenServer.start_link(Intcode, intcode_string)
    {:ok, b} = GenServer.start_link(Intcode, intcode_string)
    {:ok, c} = GenServer.start_link(Intcode, intcode_string)
    {:ok, d} = GenServer.start_link(Intcode, intcode_string)
    {:ok, e} = GenServer.start_link(Intcode, intcode_string)

    [a, b, c, d, e]
  end
end
