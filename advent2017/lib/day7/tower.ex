defmodule Advent2017.Day7 do
  defmodule Disc do
    defstruct name: "",
              weight: 0,
              missing_children: [],
              children: []

    defp w(weight) do
      weight
      |> String.replace(~r/\(|\)/, "")
      |> String.to_integer
    end

    defp c(children) do
      children
      |> String.split(", ", [trim: true])
    end

    def new([name_and_weight]) do
      [name, weight] = String.split(name_and_weight, " ")
      %Disc{name: name, weight: w(weight)}
    end

    def new([name_and_weight, children]) do
      [name, weight] = String.split(name_and_weight, " ")
      %Disc{name: name, weight: w(weight), missing_children: c(children)}
    end

    def add_child(disc, child) do
      %{disc |
        missing_children: Enum.reject(disc.missing_children,
                                      &(&1 == child.name)),
        children: [child | disc.children]}
    end
  end

  @doc """
  find a root node w/ missing_children
  if nothing, recurse on children
  """
  def find_parent([], orphan), do: orphan
  def find_parent(tree, orphan) do
    Enum.reduce(tree, fn (possible_parent, tower) ->
      if Enum.any?(possible_parent.missing_children, orphan.name) do
        Disc.add_child(possible_parent, orphan)
      else
        %{possible_parent | children: find_parent(possible_parent.children, orphan)}
      end
    end)
  end

  @doc """
  For each n, we need to find it's proper place in the tower, which is the acc
  here. We should check tower for a missing_children slot matching n, place it.
  """
  def build_tower(tree) when length(tree) == 1, do: tree
  def build_tower(tree) do
    Enum.reduce(tree, [], fn(orphan, tower) ->
      tower
      |> find_parent(orphan)
    end)
    |> build_tower # repeat until we only have one root node
  end

  def load_file_into_nodes(file_name) do
    {:ok, file} = File.read("lib/day7/#{file_name}")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(&(String.split(&1, " -> ", [trim: true])))
    |> Enum.map(&(Disc.new &1))
    |> Enum.sort # this orders the leaf nodes first in the list
  end

  def p1 do
    load_file_into_nodes("test.txt")
    |> build_tower
  end

  def p2, do: nil
end
