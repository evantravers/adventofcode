defmodule Advent2017.Day7.Disc do
  defstruct name: "", weight: 0, children: MapSet.new

  defp w(weight) do
    weight
    |> String.replace(~r/\(|\)/, "")
    |> String.to_integer
  end

  defp c(children, nodes) do
    children
    |> String.split(", ", [trim: true])
    |> MapSet.new
  end

  def new([name_and_weight], nodes) do
    [name, weight] = String.split(name_and_weight, " ")
    %Advent2017.Day7.Disc{name: name, weight: w(weight)}
  end

  def new([name_and_weight, children], nodes) do
    [name, weight] = String.split(name_and_weight, " ")
    %Advent2017.Day7.Disc{name: name, weight: w(weight), children: c(children)}
  end
end

defmodule Advent2017.Day7 do
  def p1, do: nil
  def p2, do: nil

  @doc ~S"""
      iex> Advent2017.Day7.load_file_into_nodes("test.txt")
      ...> |> Advent2017.Day7.build_tower
      ...> |> Advent2017.Day7.base
      "tknk"
  """
  def build_tower(file_name) do
    file_name
  end

  def load_file_into_nodes(file_name) do
    {:ok, file} = File.read("lib/day7/#{file_name}")

    IO.inspect file

    MapSet.new(
      file
      |> String.split("\n", [trim: true])
      |> Enum.map(&(String.split(&1, " -> ", [trim: true])))
      |> Enum.map(&(Advent2017.Day7.Disc.new &1))
    )
  end
end
