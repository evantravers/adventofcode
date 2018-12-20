defmodule Advent2018.Day7 do
  @moduledoc "https://adventofcode.com/2018/day/7"

  def load_input(file \\ "input.txt") do
    with {:ok, file} <- File.read("#{__DIR__}/#{file}") do
      file
      |> String.split("\n", trim: true)
      |> Enum.reduce(Graph.new(), &read_string_into_graph/2)
    end
  end

  def load_weights(graph, offset \\ 60) do
    graph
    |> Graph.vertices
    |> Enum.map(&{&1, weight(&1, offset)})
    |> Enum.into(%{})
  end

  @doc """
      iex> weight("A")
      61
      iex> weight("Z")
      86
  """
  def weight(label, offset \\ 60) do
    ?A..?Z
    |> Enum.find_index(&hd(String.to_charlist(label)) == &1)
    |> Kernel.+(offset + 1)
  end

  def read_string_into_graph(str, graph) do
    [[_, parent], [_, child]] =
      ~r/step ([A-Z])/i
      |> Regex.scan(str)

    graph
    |> Graph.add_edge(parent, child)
  end

  def reqs_satisfied(graph, node, visited) do
    not Enum.member?(visited, node)

    and

    (
      graph
      |> Graph.in_neighbors(node)
      |> Enum.empty?

      or

      graph
      |> Graph.in_neighbors(node)
      |> Enum.all?(&Enum.member?(visited, &1))
    )
  end

  def completed?(work_remaining, node) do
    case Map.get(work_remaining, node) do
      nil -> true
      0 -> true
      _ -> false
    end
  end

  def work(map, list_of_nodes) do
    list_of_nodes
    |> Enum.reduce(map, fn(node, work_remaining) ->
      Map.update(work_remaining, node, 0, & &1 - 1)
    end)
  end

  def search(graph, work_remaining \\ %{}, workers \\ 1, visited \\ [], seconds \\ 0) do
    to_visit =
      graph
      |> Graph.vertices
      |> Enum.filter(&reqs_satisfied(graph, &1, visited))
      |> Enum.sort

    # update work_remaining
    in_progress =
      to_visit
      |> Enum.take(workers)

    completed =
      in_progress
      |> Enum.filter(&completed?(work_remaining, &1))

    if Enum.empty?(to_visit) do
      %{
        result: visited
                |> Enum.reverse
                |> Enum.join,
        seconds: seconds
      }
    else
      search(graph, work(work_remaining, in_progress), workers, completed ++ visited, seconds + 1)
    end
  end

  def p1 do
    load_input()
    |> search
    |> Map.get(:result)
  end

  def p2 do
    graph   = load_input()
    weights = load_weights(graph)

    graph
    |> search(weights, 5)
    |> Map.get(:seconds)
  end
end
