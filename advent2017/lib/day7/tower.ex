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
      wishlist = Enum.reject(disc.missing_children, &(&1 == child.name))
      %{disc | missing_children: wishlist, children: [child | disc.children]}
    end
  end

  def build_tower(root) when length(root) == 1, do: root # win condition
  def build_tower([orphan | remaining_nodes]) do
    # search remaining for this orphan's parent
    parent = search(orphan.name, remaining_nodes)

    cond do
      !is_nil(parent) ->
        new_parent = Disc.add_child(parent, orphan)
        build_tower([new_parent | List.delete(remaining_nodes, parent)])
      true ->
        build_tower([remaining_nodes ++ [orphan]])
    end
  end

  @spec search(charlist, list) :: Disc
  def search(_, []), do: nil
  def search(target, [h|t]) do
    cond do
      Enum.any?(h.missing_children, &(target == &1)) ->
        h
      true ->
        search(target, h.children)
        search(target, t)
    end
  end

  def load_file_into_nodes(file_name) do
    {:ok, file} = File.read("lib/day7/#{file_name}")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(&(String.split(&1, " -> ", [trim: true])))
    |> Enum.map(&(Disc.new &1))
  end

  def p1 do
    load_file_into_nodes("test.txt")
    |> build_tower
  end

  def p2, do: nil
end
