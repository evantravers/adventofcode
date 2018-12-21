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

  def possible?(graph, node, visited) do
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

  def completed?(work_required, node), do: Map.get(work_required, node, 1) == 1

  def work(work_required, list_of_nodes) do
    Enum.reduce(list_of_nodes, work_required, fn(node, remaining_work) ->
      Map.update(remaining_work, node, 0, & &1 - 1)
    end)
  end

  def search(graph, work_required \\ %{}, workers \\ 1, working \\ [], visited \\ [], seconds \\ 0) do
    if Enum.count(Graph.vertices(graph)) == Enum.count(visited) do
      %{
        result: Enum.join(visited),
        seconds: seconds
      }
    else
      todo =
        graph
        |> Graph.vertices
        |> Enum.filter(&possible?(graph, &1, visited))
        |> Enum.sort
        |> Enum.take(workers - Enum.count(working))
        |> Enum.concat(working)
        |> Enum.uniq

      completed = Enum.filter(todo, &completed?(work_required, &1))
      # IO.puts("#{seconds}s\t-\t#{show_workers(workers, todo, work_required)}\t-\t#{Enum.join(visited, ",")}")

      search(
        graph,
        work(work_required, todo),
        workers,
        todo -- completed,
        visited ++ completed,
        seconds + 1)
    end
  end

  def show_workers(workers, todo, work_required) do
    for worker <- 1..workers do
      node = Enum.at(todo, worker - 1)
      if !is_nil(node) do
        "#{node}:#{Map.get(work_required, node)}"
      else
        "."
      end
    end
    |> Enum.join("\t")
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

  def test do
    graph   = load_input("test.txt")
    weights = load_weights(graph, 0)

    graph
    |> search(weights, 2)
    |> Map.get(:seconds)
  end
end
