defmodule Advent2019.Day13 do
  @moduledoc "https://adventofcode.com/2019/day/13"

  def setup do
    with {:ok, intcode_string} <- File.read("#{__DIR__}/input.txt") do
      intcode_string
    end
  end

  defmodule Game do
    @moduledoc nil

    defstruct tiles: %{}, score: 0

    @spec read_input(list(integer)) :: map()
    @doc """
        iex> read_input([1,2,3,6,5,4])
        %{{1, 2} => :paddle, {6, 5} => :ball}
    """
    def read_input(list_of_int) do
      list_of_int
      |> Enum.chunk_every(3)
      |> Enum.reduce(%Game{}, fn([x, y, id], game) ->
        if {x, y} == {-1, 0} do
          Map.put(game, :score, id)
        else
          Map.update!(game, :tiles, fn(tiles) ->
            Map.put(tiles, {x, y}, id_to_object(id))
          end)
        end
      end)
    end

    defp id_to_object(0), do: nil
    defp id_to_object(1), do: :wall
    defp id_to_object(2), do: :block
    defp id_to_object(3), do: :paddle
    defp id_to_object(4), do: :ball
  end

  def p1(source_code) do
    source_code
    |> Intcode.load_string
    |> Intcode.start
    |> Map.get(:output)
    |> Enum.reverse
    |> Game.read_input
    |> Map.get(:tiles)
    |> Enum.filter(fn({_coord, type}) -> type == :block end)
    |> Enum.count
  end

  def p2(source_code) do
    source_code
    |> Intcode.load_string
    |> Intcode.set_memory(0, 2) # put in your quarters
    |> Intcode.start
    |> Map.get(:output)
    |> Enum.reverse
    |> Game.read_input
    |> Map.get(:score)
  end
end
