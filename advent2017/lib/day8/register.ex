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

  def run(instructions), do: run(instructions, [%{}])
  def run([], history), do: history
  def run([i|next], history) do
    current = hd(history)

    target = get_register(current, i["target"])

    {result, _} = Code.eval_string("#{target} #{i["condition"]} #{i["value"]}")

    cond do
      result ->
        future =
          Map.put(current, i["register"], change(i["direction"], get_register(current, i["register"]), i["amount"]))
        run(next, [future | history])
      true ->
        run(next, [current | history])
    end
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
    |> List.first
    |> Map.values
    |> Enum.max
  end

  def p2 do
    load_instructions("input.txt")
    |> run
    |> Enum.map(&(Map.values(&1)))
    |> Enum.map(&(Enum.max(&1, fn -> 0 end)))
    |> Enum.max
  end
end
