defmodule Advent2020.Day13 do
  @moduledoc "https://adventofcode.com/2020/day/13"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input") do
      [stamp, buses] = String.split(file, "\n", trim: true)

      %{
        timestamp: String.to_integer(stamp),
        buses: buses
               |> String.split(",")
               |> Enum.map(&process_departure/1)
               |> Enum.reject(& is_nil(&1))
      }
    end
  end

  def process_departure("x"), do: nil
  def process_departure(bus), do: String.to_integer(bus)

  @doc """
      iex> %{timestamp: 939, buses: [7,13,59,31,19]}
      ...> |> p1
      295
  """
  def p1(%{timestamp: timestamp, buses: buses}) do
    winner =
      buses
      |> Enum.map(fn(bus) ->
        min_rotations = ceil(timestamp / bus)

        %{bus: bus, first: bus * min_rotations}
      end)
      |> Enum.min_by(fn(%{first: first}) ->
        first - timestamp
      end)

    Map.get(winner, :bus) * (Map.get(winner, :first) - timestamp)
  end

  def p2(_input), do: nil
end
