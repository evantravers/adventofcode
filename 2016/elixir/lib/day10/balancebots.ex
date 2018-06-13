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
  `setup_sim` loads in the input, and sets up a map of bots, with their inputs
  and rules.
  """
  def setup_sim do
    load_input()
    |> Enum.reduce(%{}, &read_instruction/2)
  end

  @doc """
  Pulls the arguments out of the string.
  Takes the "target id" string and transforms it into a list:
  `[:atom, integer]`. We use this as part of the path to identify bots and
  outputs in the sim.
  """
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
  `read_instruction/2` is designed to be used as the function in a reduce.

  For a string in the input, it evaluates it, pulls out the rules or input and
  puts it in the `sim` map.
  """
  def read_instruction(match = "value" <> _, sim) do # input
    [[_, value], [_, bot_id]] = extract_arguments(match)

    update_in(sim,
              build_path([:bot, bot_id]) ++ [Access.key(:cargo, [])],
              fn(cargo) -> [value|cargo] end)
  end
  def read_instruction(match = "bot" <> _, sim) do # rules
    [[:bot, bot_id], low, high] = extract_arguments(match)

    sim
    |> put_in(build_path([:bot, bot_id, :low]), low)
    |> put_in(build_path([:bot, bot_id, :high]), high)
  end

  def find_unresolved_bots(sim) do
    sim
    |> Map.get(:bot)
    |> Enum.filter(fn({_, att}) ->
      Map.has_key?(att, :cargo) && Enum.count(Map.get(att, :cargo)) > 1
    end)
  end

  @doc """
  Takes in a list of unresolved bots (bots w/ two chips) and the sim, and puts
  out a sim where their chips have been evaluated.
  """
  def redistribute_chips(unresolved_bots, sim) do
    unresolved_bots
    |> Enum.reduce(sim, fn({id, attr}, sim) ->
      sim
      |> distribute_chip(attr.high, Enum.max(attr.cargo))
      |> distribute_chip(attr.low, Enum.min(attr.cargo))
      |> clear_cargo(id)
    end)
  end

  @doc """
  Find bots w/ two cargo, resolve, repeat until done.
  """
  def run(sim, watch \\ [-1, -1]) do
    if Enum.empty?(find_unresolved_bots(sim)) do
      sim
    else
      if Enum.find(find_unresolved_bots(sim), fn({id, attr}) -> Map.get(attr, :cargo) == watch end) do
        Enum.find(find_unresolved_bots(sim), fn({id, attr}) -> Map.get(attr, :cargo) == watch end) |> elem(0)
      else
        sim
        |> find_unresolved_bots
        |> redistribute_chips(sim)
        |> run(watch)
      end
    end
  end

  def distribute_chip(sim, target, chip) do
    update_in(sim, build_path(target) ++ [:cargo], & [chip|List.wrap(&1)])
  end

  def clear_cargo(sim, bot_id) do
    sim
    |> pop_in([:bot, bot_id, :cargo])
    |> elem(1) # throw away the popped value
  end

  def build_path(list_of_keys) do
    list_of_keys
    |> Enum.map(&Access.key(&1, %{}))
  end

  def get_output(sim, num) do
    sim
    |> get_in([:output, num, :cargo])
    |> hd
  end

  def p1 do
    setup_sim()
    |> run([17, 61])
  end

  def p2 do
    result =
      setup_sim()
      |> run

    get_output(result, 0) * get_output(result, 1) * get_output(result, 2)
  end
end
