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

    @spec read_input(list(integer)) :: map()
    @doc """
        iex> read_input([1,2,3,6,5,4])
        %{{1, 2} => :paddle, {6, 5} => :ball}
    """
    def read_input(list_of_int) do
      list_of_int
      |> Enum.chunk_every(3)
      |> Enum.reduce([], fn([x, y, id], tiles) ->
        [{{x, y}, id_to_object(id)}|tiles]
      end)
      |> Enum.reject(&is_nil(elem(&1, 1)))
      |> Map.new
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
    |> Enum.filter(fn({_coord, type}) -> type == :block end)
    |> Enum.count
  end

  def p2(_source_code) do
  end
end
