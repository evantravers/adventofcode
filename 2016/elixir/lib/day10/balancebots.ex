defmodule Advent2016.Day10 do
  @moduledoc """
  http://adventofcode.com/2016/day/10
  """

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input") do
      file
      |> String.split("\n", trim: true)
    end
  end

  @doc """
  `setup_sim` loads in the input, and sets up a map of bots
  """
  def setup_sim do
    load_input()
    |> Enum.reduce(%{}, &read_instruction/2)
  end

  @doc "Pulls the arguments out of the string"
  def extract_arguments(string) do
    ~r/\w+ \d+/
    |> Regex.scan(string)
    |> List.flatten
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn([target, id]) ->
      [String.to_atom(target), String.to_integer(id)]
    end)
  end

  @doc """
  `read_instruction/2` is designed to be used as part of a reduce... it goes
  through the input and if the input is a setup instruction, it puts it in the
  first list in the `acc`, otherwise the second.

  %{bot_id => %{rules: {high_target, low_target}, cargo: []}}
  """
  def read_instruction(match = "value" <> _, sim) do # input
    [[_, value], [_, bot_id]] = extract_arguments(match)

    sim
    |> update_in(
      [Access.key(:bot, %{}), Access.key(bot_id, %{}), Access.key(:cargo, [])],
      fn(cargo) -> cargo ++ List.wrap(value) end)
  end
  def read_instruction(match = "bot" <> _, sim) do # rules
    [[:bot, bot_id], low, high] = extract_arguments(match)

    sim
    |> put_in(build_as_go([:bot, bot_id, :low]), low)
    |> put_in(build_as_go([:bot, bot_id, :high]), high)
  end

  def unresolved_bots(sim) do
    sim
    |> Map.get(:bot)
    |> Enum.filter(fn({_, att}) ->
      Map.has_key?(att, :cargo) && Enum.count(Map.get(att, :cargo)) > 1
    end)
  end

  @doc """
  Find a bot w/ two cargo, resolve, repeat until done.
  """
  def run(sim) do
    if Enum.empty?(unresolved_bots(sim)) do
      sim
    else
      sim
      |> unresolved_bots
      |> Enum.reduce(sim, fn({id, attr}, sim) ->
        sim
        |> update_in(build_as_go(attr.high) ++ [:cargo], & [Enum.max(attr.cargo)|List.wrap(&1)])
        |> update_in(build_as_go(attr.low) ++ [:cargo], & [Enum.min(attr.cargo)|List.wrap(&1)])
        |> pop_in([:bot, id, :cargo])
        |> elem(1) # throw away the popped value
      end)
      |> run
    end
  end

  def build_as_go(list_of_keys) do
    list_of_keys
    |> Enum.map(&Access.key(&1, %{}))
  end

  def p1 do
    setup_sim()
    |> run
  end

  def p2 do
    setup_sim()
    |> run
  end
end
