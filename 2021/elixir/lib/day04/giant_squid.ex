defmodule Advent2021.Day4 do
  @moduledoc "https://adventofcode.com/2021/day/4"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt"), do: setup_string(file)
  end

  def setup_string(file) do
    fields = String.split(file, "\n\n", trim: true)

    numbers =
      fields
      |> hd
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    boards =
      fields
      |> tl
      |> Enum.map(&build_board/1)

    %{numbers: numbers, boards: boards}
  end

  def build_board(str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.reduce(%{location: %{}, marked: %{}}, fn({row, y}, board) ->
      row
      |> String.split(" ", trim: true)
      |> Enum.with_index
      |> Enum.reduce(board, fn({num, x}, board) ->
        board
        |> Map.update!(:location, &Map.put(&1, String.to_integer(num), {x, y}))
        |> Map.update!(:marked, &Map.put(&1, {x, y}, false))
      end)
    end)
  end

  def bingo?(%{marked: marked}) do
    [
      # diagonals
      [{0, 0}, {1, 1}, {2, 2}, {3, 3}, {4, 4}],
      [{0, 4}, {1, 3}, {2, 2}, {3, 1}, {4, 0}],
      # horizontal
      [{0, 0}, {1, 0}, {2, 0}, {3, 0}, {4, 0}],
      [{0, 1}, {1, 1}, {2, 1}, {3, 1}, {4, 1}],
      [{0, 2}, {1, 2}, {2, 2}, {3, 2}, {4, 2}],
      [{0, 3}, {1, 3}, {2, 3}, {3, 3}, {4, 3}],
      [{0, 4}, {1, 4}, {2, 4}, {3, 4}, {4, 4}],
      # vertical
      [{0, 0}, {0, 1}, {0, 2}, {0, 3}, {0, 4}],
      [{1, 0}, {1, 1}, {1, 2}, {1, 3}, {1, 4}],
      [{2, 0}, {2, 1}, {2, 2}, {2, 3}, {2, 4}],
      [{3, 0}, {3, 1}, {3, 2}, {3, 3}, {3, 4}],
      [{4, 0}, {4, 1}, {4, 2}, {4, 3}, {4, 4}],
    ]
    |> Enum.any?(fn(list_of_coords) -> Enum.all?(list_of_coords, &Map.get(marked, &1)) end)
  end

  def call(%{location: location} = board, number) do
    coord = Map.get(location, number)

    if coord do
      Map.update!(board, :marked, &Map.put(&1, coord, true))
    else
      board
    end
  end

  def unmarked_numbers(%{location: location, marked: marked}) do
    squares =
      location
      |> Enum.map(fn{key, val} -> {val, key} end)
      |> Enum.into(%{})

    marked
    |> Enum.reject(&elem(&1, 1))
    |> Enum.map(&elem(&1, 0))
    |> Enum.map(&Map.get(squares, &1))
  end

  @doc """
      iex> "7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1
      ...>
      ...>22 13 17 11  0
      ...> 8  2 23  4 24
      ...>21  9 14 16  7
      ...> 6 10  3 18  5
      ...> 1 12 20 15 19
      ...>
      ...> 3 15  0  2 22
      ...> 9 18 13 17  5
      ...>19  8  7 25 23
      ...>20 11 10 24  4
      ...>14 21 16 12  6
      ...>
      ...>14 21 17 24  4
      ...>10 16 15  9 19
      ...>18  8 23 26 20
      ...>22 11 13  6  5
      ...> 2  0 12  3  7"
      ...> |> setup_string
      ...> |> p1
      4512
  """
  def p1(%{numbers: numbers} = state) do
    {winner, number} =
      numbers
      |> Enum.reduce_while(state, fn(number, %{boards: boards} = state) ->
        # call out the number
        new_boards = Enum.map(boards, &call(&1, number))

        if Enum.any?(new_boards, &bingo?/1) do
          winner = Enum.find(new_boards, &bingo?/1)
          {:halt, {winner, number}}
        else
          {:cont, %{state | boards: new_boards}}
        end
      end)

    winner
    |> unmarked_numbers
    |> Enum.sum
    |> Kernel.*(number)
  end

  def p2(_i), do: nil
end
