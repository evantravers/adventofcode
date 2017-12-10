require IEx

defmodule Advent2017.Day8 do
  @command_pattern ~r/(?<register>\w+) (?<direction>\w+) (?<amount>(|-)\d+) if (?<target>\w+) (?<condition>[!<>=]+) (?<value>(|-)\d+)/

  def load_instructions(filename) do
    {:ok, file} = File.read("./lib/day8/#{filename}")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(fn line ->
      Regex.named_captures(@command_pattern, line)
    end)
    |> Enum.map(fn(command) ->
      command
      |> Map.update!("value",  &(String.to_integer(&1)))
      |> Map.update!("amount", &(String.to_integer(&1)))
    end)
  end

  def run(instructions), do: run(instructions, %{})
  def run([], state), do: state
  def run([i|next], state) do
    target = get_register(state, i["target"])

    {result, _} = Code.eval_string("#{target} #{i["condition"]} #{i["value"]}")

    if result do
      state =
        Map.put(state, i["register"], change(i["direction"], get_register(state, i["register"]), i["amount"]))
    end

    run(next, state)
  end

  def change("inc", num, amount), do: num + amount
  def change("dec", num, amount), do: num - amount

  def get_register(state, register) do
    Map.get(state, register) || 0
  end

  def test do
    load_instructions("test.txt")
    |> run
    |> Map.values
    |> Enum.max
  end

  def p1 do
    load_instructions("input.txt")
    |> run
    |> Map.values
    |> Enum.max
  end

  def p2 do
    load_instructions("input.txt")
  end
end
