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

  # After reading wikipedia, I finally understood this gorgeous code:
  # https://github.com/h-j-k/advent20/blob/master/lib/advent_of_code/day13.ex
  def sieve({bus, offset}, {start, step}) do
    if rem(start + offset, bus) == 0 do
      {start, (&(div(&1 * &2, Integer.gcd(&1, &2)))).(bus, step)}
    else
      sieve({bus,offset}, {start + step, step})
    end
  end

  @doc """
  I've been thinking about this one a lot, and I think I want to have each
  "bus" build a generator of an series... then I could theoretically ask the
  series generators which set of numbers satisfies the order.

      iex> "939
      ...>7,13,x,x,59,x,31,19"
      ...> |> setup_string
      ...> |> p2
      1068781

      iex> "939
      ...>67,7,59,61"
      ...> |> setup_string
      ...> |> p2
      754018

      iex> "939
      ...>67,x,7,59,61"
      ...> |> setup_string
      ...> |> p2
      779210

      iex> "939
      ...>67,7,x,59,61"
      ...> |> setup_string
      ...> |> p2
      1261476
  """
  def p2(%{buses: buses}) do
    buses
    |> Enum.reject(& elem(&1, 0) == "x" )
    |> Enum.map(fn{b, offset} -> {String.to_integer(b), offset} end)
    |> Enum.reduce({0, 1}, &sieve/2)
    |> elem(0)
  end
end
