require IEx

defmodule Advent2017.Day7 do
  @doc """
  Tree Structure %{"id" => %{tree: %{}, weight: 0}}
  """
  def read_input(file_name) do
    {:ok, file} = File.read("lib/day7/#{file_name}")
    disc = ~r/(?<name>.+) \((?<weight>\d+)\)( -> (?<children>.+))*/

    file
    |> String.split("\n", [trim: true])
    |> Enum.reduce(%{}, fn (pattern, tower) ->
      if pattern =~ "->" do
        [_, name, weight, _, children] = Regex.run(disc, pattern)
        build_tower(tower, name, weight, String.split(children, ", ", [trim: true]))
      else
        [_, name, weight] = Regex.run(disc, pattern)
        build_tower(tower, name, weight)
      end
    end)
  end

  def w(string), do: String.to_integer(string)

  def build_tower(tower, name, weight \\ nil) do
    if tower[name] do
      put_in(tower, [name, :weight], weight)
    else
      put_in(tower, [name], %{weight: weight, above: [], below: []})
    end
  end

  def build_tower(tower, name, weight, children) do
    build_tower(tower, name, weight)
    |> put_in([name, :above], children)
    |> (&Enum.reduce(children, &1, fn child_name, tower ->
      new_tower =
        unless tower[child_name] do
          build_tower(tower, child_name)
        else
          tower
        end
      put_in(new_tower, [child_name, :below], new_tower[child_name][:below] ++ [name])
    end)).()
  end

  def test do
    read_input("test.txt")
  end

  def p1 do
    read_input("input.txt")
  end

  def p2, do: nil
end
