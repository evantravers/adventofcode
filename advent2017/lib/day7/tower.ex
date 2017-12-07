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

    def find_child(disc, child) do
      wishlist = Enum.reject(disc.missing_children, &(&1 == child.name))
      %{disc | missing_children: wishlist, children: [child | disc.children]}
    end
  end

  def build_tower(root) when length(root) == 1, do: root # win condition
  def build_tower([orphan | remaining_nodes]) do
    # I have a list of nodes that haven't been placed yet.
    # for each element
    #   look through the tree, make sure there's not a parent waiting for it.
    #     if all elements come up nil, it's the root, I could stop there.
    remaining_nodes
    |> Enum.map(fn(possible) ->
      cond do
        # if a match exists
        #   make a new copy of remaining nodes w/ the updated find_child()
        #   call build_tower on remaining_nodes
        true -> # next, put it to the end of the list and keep on
          build_tower([remaining_nodes ++ [orphan]])
      end
    end)
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
    |> List.first
  end

  def p2, do: nil
end
