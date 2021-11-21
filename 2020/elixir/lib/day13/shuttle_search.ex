defmodule Advent2020.Day13 do
  @moduledoc "https://adventofcode.com/2020/day/13"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input") do
      setup_string(file)
    end
  end

  def setup_string(str) do
    [stamp, buses] = String.split(str, "\n", trim: true)

    %{
      timestamp: String.to_integer(stamp),
      buses: buses
             |> String.split(",", trim: true)
             |> Enum.with_index
    }
  end

  @doc """
      iex> "939
      ...>7,13,x,x,59,x,31,19"
      ...> |> setup_string
      ...> |> p1
      295
  """
  def p1(%{timestamp: timestamp, buses: buses}) do
    winner =
      buses
      |> Enum.map(fn
        {"x", _index} -> nil
        {bus, _index} ->
          bus = String.to_integer(bus)
          min_rotations = ceil(timestamp / bus)

          %{bus: bus, first: bus * min_rotations}
      end)
      |> Enum.reject(&is_nil/1)
      |> Enum.min_by(fn(%{first: first}) ->
        first - timestamp
      end)

    Map.get(winner, :bus) * (Map.get(winner, :first) - timestamp)
  end

  def p2(_input), do: nil
end
