defmodule Advent2017.Day7 do
  defmodule Disc do
    defstruct name: "", weight: 0, children: MapSet.new

    defp w(weight) do
      weight
      |> String.replace(~r/\(|\)/, "")
      |> String.to_integer
    end

    defp c(children) do
      children
      |> String.split(", ", [trim: true])
      |> MapSet.new
    end

    def new([name_and_weight]) do
      [name, weight] = String.split(name_and_weight, " ")
      %Disc{name: name, weight: w(weight)}
    end

    def new([name_and_weight, children]) do
      [name, weight] = String.split(name_and_weight, " ")
      %Disc{name: name, weight: w(weight), children: c(children)}
    end
  end

  def p1 do
    load_file_into_nodes("input.txt")
    |> build_tower
    |> Enum.at(0)
  end
  def p2, do: nil

  def build_tower(nodes) do
    nodes
    |> Enum.reduce(MapSet.new, fn(n, tree) ->
      
    end)
  end

  def load_file_into_nodes(file_name) do
    {:ok, file} = File.read("lib/day7/#{file_name}")

    MapSet.new(
      file
      |> String.split("\n", [trim: true])
      |> Enum.map(&(String.split(&1, " -> ", [trim: true])))
      |> Enum.map(&(Disc.new &1))
    )
  end
end
