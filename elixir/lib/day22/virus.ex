require IEx

defmodule Advent2017.Day22 do
  @moduledoc """
  Diagnostics indicate that the local grid computing cluster has been
  contaminated with the Sporifica Virus. The grid computing cluster is a
  seemingly-infinite two-dimensional grid of compute nodes. Each node is either
  clean or infected by the virus.

  To prevent overloading the nodes (which would render them useless to the
  virus) or detection by system administrators, exactly one virus carrier moves
  through the network, infecting or cleaning nodes as it moves. The virus
  carrier is always located on a single node in the network (the current node)
  and keeps track of the direction it is facing.

  To avoid detection, the virus carrier works in bursts; in each burst, it
  wakes up, does some work, and goes back to sleep. The following steps are all
  executed in order one time each burst:

  If the current node is infected, it turns to its right. Otherwise, it turns
  to its left. (Turning is done in-place; the current node does not change.) If
  the current node is clean, it becomes infected. Otherwise, it becomes
  cleaned. (This is done after the node is considered for the purposes of
  changing direction.) The virus carrier moves forward one node in the
  direction it is facing.  Diagnostics have also provided a map of the node
  infection status (your puzzle input). Clean nodes are shown as .; infected
  nodes are shown as #. This map only shows the center of the grid; there are
  many more nodes beyond those shown, but none of them are currently infected.
  """

  defmodule Virus do
    defstruct coord: {0, 0}, dir: :u, infected: 0

    def burst({virus, grid}) do
      if Enum.member? Map.keys(grid), virus.coord do # infected
        {virus |> turn(:r) |> move, clean(grid, virus)}
      else
        {virus |> turn(:l) |> move |> inc_infected, infect(grid, virus)}
      end
    end

    @doc """
    Turns the current heading using cardinal as a sort of meta-circular
    linkedlist compass.
    """
    def turn(virus, new_dir) do
      cardinal = [:u, :r, :d, :l]
      heading = Enum.find_index(cardinal, &(virus.dir == &1))
      case new_dir do
        :l -> %{virus | dir: Enum.at(cardinal, rem(heading - 1, 4))}
        :r -> %{virus | dir: Enum.at(cardinal, rem(heading + 1, 4))}
      end
    end

    def move(virus) do
      {x, y} = virus.coord
      case virus.dir do
        :u -> %{virus | coord: {x, y - 1}}
        :d -> %{virus | coord: {x, y + 1}}
        :l -> %{virus | coord: {x - 1, y}}
        :r -> %{virus | coord: {x + 1, y}}
      end
    end

    def inc_infected(virus) do
      %Virus{virus | infected: virus.infected + 1}
    end

    def infect(g, v) do
      {x, y} = v.coord
      Map.put(g, {x, y}, :infected)
    end

    def clean(g, v) do
      Map.delete(g, v.coord)
    end

    def pp(grid, virus \\ %Virus{}) do
      limit =
        grid
        |> Enum.map(&Tuple.to_list &1)
        |> List.flatten
        |> Enum.map(&abs &1)
        |> Enum.max
      representation = ""
      Enum.map(-limit..limit, fn y ->
        Enum.map(-limit..limit, fn x ->
          d =
            case {x, y} == virus.coord do
              true -> "^"
              false -> " "
            end
          case Enum.member? grid, {x, y} do
            true -> representation <> "#{d}##{d}"
            false -> representation <> "#{d}.#{d}"
          end
        end)
        |> Enum.join
        |> Kernel.<>("\n")
      end)
      |> Enum.join
    end
  end

  def load_node_map(filename) do
    {:ok, file} = File.read(__DIR__ <> "/#{filename}")

    file
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split &1, "", trim: true)
    |> Enum.with_index
    |> Enum.map(fn {row, y} ->
      row
      |> Enum.with_index
      |> Enum.reduce([], fn {val, x}, coords ->
        offset = div(length(row), 2)
        case val do
          "#" -> [{{x-offset, y-offset}, :infected}|coords]
          "." -> coords
        end
      end)
    end)
    |> Enum.concat
    |> Map.new
  end

  def iterate({virus, grid}, 0), do: {virus, grid}
  def iterate({virus, grid}, count) do
    iterate(Virus.burst({virus, grid}), count - 1)
  end

  def test do
    grid = load_node_map("test.txt")
    {virus, grid} = iterate({%Virus{}, grid}, 10_000)
  end

  def p1 do
    grid = load_node_map("input.txt")
    {virus, grid} = iterate({%Virus{}, grid}, 10_000)
    virus.infected
  end
end
