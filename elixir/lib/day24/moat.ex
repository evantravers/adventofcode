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
  def build_graph(filename) do
    {:ok, file} = File.read(__DIR__ <> "/#{filename}")

    edges =
      file
      |> String.split("\n", trim: true)
      |> Enum.map(fn component ->
        [v1, v2] = component
                   |> String.split("/")
                   |> Enum.map(&String.to_integer &1)

        Graph.Edge.new(v1, v2, weight: v1 + v2)
      end)

    Graph.add_edges(Graph.new, edges)
  end
end
