defmodule Advent2018.Day12 do
  @moduledoc """
  https://adventofcode.com/2018/day/12
  """

  def load_input(file \\ "input.txt") do
    with {:ok, input} <- File.read("#{__DIR__}/#{file}") do
      [initial|rules] = String.split(input, "\n", trim: true)

      {extract_initial(initial), extract_rules(rules)}
    end
  end

  def pot_or_not(str) do
    str
    |> String.graphemes
    |> Enum.map(& &1 == "#")
  end

  def extract_initial(str) do
    ~r/(#|\.)+/
      |> Regex.run(str)
      |> hd
      |> pot_or_not
      |> list_to_set
  end

  def list_to_set(list) do
    list
    |> Enum.with_index
    |> Enum.filter(&elem(&1, 0))
    |> Enum.map(&elem(&1, 1))
    |> Enum.into(MapSet.new)
  end

  def extract_rules(list_of_strings) do
    list_of_strings
    |> Enum.map(fn(str) ->
      str
      |> String.split(" => ")
      |> (fn([pattern, result]) -> {pot_or_not(pattern), result == "#"} end).()
    end)
    |> Enum.filter(fn({_, result}) -> result end) # TODO: unsure whether filtering out fails is a good idea...
    |> Enum.map(&elem(&1, 0))
    |> Enum.into(MapSet.new)
  end

  def scanpots(generation, index) do
    for i <- (index - 2)..(index + 2) do
      if MapSet.member?(generation, i) do
        true
      else
        false
      end
    end
  end

  def next_generation(current_generation, rules) do
    {min, max} = Enum.min_max(current_generation)
    for pot_location <- (min-2)..(max+2),
      MapSet.member?(rules, scanpots(current_generation, pot_location)),
      into: MapSet.new do
      pot_location
    end
  end

  def print_pots(generation) do
    {min, max} = Enum.min_max(generation)
    for x <- min..max do
      if MapSet.member?(generation, x) do
        "#"
      else
        "."
      end
    end
    |> Enum.join
  end

  def run_sim(generation, _, 0, _), do: generation
  def run_sim(generation, rules, num, count) do
    # IO.puts("[#{count}] = #{Enum.sum(generation)}\t#{print_pots(generation)}")
    run_sim(next_generation(generation, rules), rules, num - 1, count + 1)
  end

  def p1 do
    {starting_generation, rules} = load_input()

    run_sim(starting_generation, rules, 20, 0)
    |> Enum.sum
  end

  def p2 do
    # so after examining the shape of the function... it seems to generate a
    # "glider" that then goes up 21 per turn
    # On turn 89, it's at 2349, then increases by 21 until the end of the period.
    ((50_000_000_000 - 89) * 21) + 2_349
  end
end
