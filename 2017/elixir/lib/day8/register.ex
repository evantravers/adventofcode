require IEx

defmodule Advent2017.Day8 do
  @moduledoc """
  http://adventofcode.com/2017/day/8
  """

  @command_pattern ~r/(?<register>\w+) (?<direction>\w+) (?<amount>(|-)\d+) if (?<target>\w+) (?<condition>[!<>=]+) (?<value>(|-)\d+)/

  def load_instructions(filename) do
    {:ok, file} = File.read("#{__DIR__}/#{filename}")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(fn line -> Regex.named_captures(@command_pattern, line) end)
    |> Enum.map(fn(command) ->
      command
      |> Map.update!("value",  &(String.to_integer(&1)))
      |> Map.update!("amount", &(String.to_integer(&1)))
    end)
  end

  def run(instructions), do: run(instructions, [%{}])
  def run([], history), do: history
  def run([i|next], history) do
    current = hd(history)

    target = get_register(current, i["target"])

    {result, _} = Code.eval_string("#{target} #{i["condition"]} #{i["value"]}")

    if result do
      future =
        Map.put(current, i["register"], change(i["direction"], get_register(current, i["register"]), i["amount"]))
      run(next, [future | history])
    else
      run(next, [current | history])
    end
  end

  def change("inc", num, amount), do: num + amount
  def change("dec", num, amount), do: num - amount

  def get_register(state, register) do
    Map.get(state, register) || 0
  end

  def test do
    "test.txt"
    |> load_instructions
    |> run
    |> Map.values
    |> Enum.max
  end

  def p1 do
    "input.txt"
    |> load_instructions
    |> run
    |> List.first
    |> Map.values
    |> Enum.max
  end

  def p2 do
    "input.txt"
    |> load_instructions
    |> run
    |> Enum.map(&(Map.values(&1)))
    |> Enum.map(&(Enum.max(&1, fn -> 0 end)))
    |> Enum.max
  end
end
