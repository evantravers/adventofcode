require IEx

defmodule Advent2017.Day24 do
  @moduledoc """
  Each component has two ports, one on each end. The ports come in all
  different types, and only matching types can be connected. You take an
  inventory of the components by their port types (your puzzle input). Each
  port is identified by the number of pins it uses; more pins mean a stronger
  connection for your bridge. A 3/7 component, for example, has a type-3 port
  on one side, and a type-7 port on the other.

  Your side of the pit is metallic; a perfect surface to connect a magnetic,
  zero-pin port. Because of this, the first port you use must be of type 0.  It
  doesn't matter what type of port you end with; your goal is just to make the
  bridge as strong as possible.

  The strength of a bridge is the sum of the port types in each component. For
  example, if your bridge is made of components 0/3, 3/7, and 7/4, your bridge
  has a strength of 0+3 + 3+7 + 7+4 = 24.
  """
  def load_components(filename) do
    {:ok, file} = File.read(__DIR__ <> "/#{filename}")

    file
    |> String.split("\n", trim: true)
    |> Enum.map(fn comp ->
      comp
      |> String.split("/")
      |> Enum.map(&String.to_integer &1)
    end)
    |> Enum.with_index
  end

  def combinations(components, {[_, port], _}, path \\ []) do
    connectable =
      components
      |> Enum.filter(fn {[p1, p2], _} -> p1 == port or p2 == port end)
      |> Enum.map(fn {[p1, p2], id} ->
        if p1 == port do
          {[p1, p2], id}
        else
          {[p2, p1], id}
        end
      end)

    if Enum.empty? connectable do
      [path]
    else
      connectable
      |> Enum.map(fn next ->
        components
        |> remove_used(next)
        |> combinations(next, [next|path])
      end)
      |> Enum.concat
    end
  end
  defp remove_used(components, {[_, _], id}) do
    List.keydelete(components, id, 1)
  end

  def weigh(list) do
    Enum.reduce(list, 0, fn {[p1, p2], _}, weight -> weight + p1 + p2 end)
  end

  def p1 do
    "input.txt"
    |> load_components
    |> combinations({[0, 0], nil})
    |> Enum.map(&weigh &1)
    |> Enum.max
  end

  def p2 do
    paths =
      "input.txt"
      |> load_components
      |> combinations({[0, 0], nil})

    longest =
      paths
      |> Enum.map(fn path -> {path, length(path)} end)
      |> List.keysort(1)
      |> Enum.reverse
      |> List.first
      |> (fn {_, size} -> size end).()

    paths
    |> Enum.filter(fn path -> length(path) == longest end)
    |> Enum.map(&weigh &1)
    |> Enum.max
  end
end
