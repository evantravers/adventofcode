defmodule Advent2019.Day13 do
  @moduledoc "https://adventofcode.com/2019/day/13"

  def setup do
    with {:ok, intcode_string} <- File.read("#{__DIR__}/input.txt") do
      intcode_string
    end
  end

  defmodule Game do
    @moduledoc nil

    defstruct tiles: %{}

    @spec read_input(map(), list(integer)) :: map()
    @doc """
        iex> read_input(%{}, [1,2,3,6,5,4])
        %{{1, 2} => :paddle, {6, 5} => :ball}
    """
    def read_input(_game, list_of_int) do
      list_of_int
      |> Enum.chunk_every(3)
      |> Enum.reduce(%{}, fn([x, y, id], tiles) ->
        if id != 0 do
          Map.put(tiles, {x, y}, id_to_object(id))
        end
      end)
    end

    defp id_to_object(1), do: :wall
    defp id_to_object(2), do: :block
    defp id_to_object(3), do: :paddle
    defp id_to_object(4), do: :ball
  end

  def p1(_i) do
  end

  def p2(_i) do
  end
end
