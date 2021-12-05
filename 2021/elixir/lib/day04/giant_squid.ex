defmodule Advent2021.Day4 do
  @moduledoc "https://adventofcode.com/2021/day/4"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt"), do: setup_string(file)
  end

  def setup_string(file) do
    fields = String.split(file, "\n\n", trim: true)

    bingo_balls =
      fields
      |> hd
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    locations =
      fields
      |> tl
      |> Enum.with_index
      |> Enum.reduce(%{}, fn({board, b}, acc) ->
        board
        |> String.split("\n", trim: true)
        |> Enum.with_index
        |> Enum.reduce(acc, fn({row, y}, acc) ->
          row
          |> String.split(" ", trim: true)
          |> Enum.with_index
          |> Enum.reduce(acc, fn({char, x}, acc) ->
            Map.update(acc, String.to_integer(char), [{b, {x, y}}], &[{b, {x, y}}|&1])
          end)
        end)
      end)

    {bingo_balls, locations}
  end

  def bingo?({_index, marked}) do
    [
      # diagonals
      # [{0, 0}, {1, 1}, {2, 2}, {3, 3}, {4, 4}],
      # [{0, 4}, {1, 3}, {2, 2}, {3, 1}, {4, 0}],
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
    |> Enum.any?(fn(list_of_coords) ->
      Enum.all?(list_of_coords, &Enum.member?(marked, &1))
    end)
  end

  @doc """
  Reconstructs the board from the locations
  """
  def board(index, locations) do
    locations
    |> Enum.filter(fn({_num, coords}) ->
      Enum.any?(coords, &elem(&1, 0) == index)
    end)
    |> Enum.map(fn({num, coords}) ->
      {
        coords
        |> Enum.find(&elem(&1, 0) == index) # find the one for this board
        |> elem(1),
        num
      }
    end)
    |> Enum.into(%{})
  end

  def unmarked_numbers({index, marked}, locations) do
    board = board(index, locations)

    for x <- 0..4, y <- 0..4, into: %MapSet{} do
      {x, y}
    end
    |> MapSet.difference(marked)
    |> Enum.map(fn(coord) ->
      Map.get(board, coord)
    end)
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
  def p1({bingo_balls, locations}) do
    {winner, number} =
      bingo_balls
      |> Enum.reduce_while(%{}, fn(number, marked) ->
        # call out the ball
        boards =
          locations
          |> Map.get(number)
          |> Enum.reduce(marked, fn({index, coord}, marked) ->
            marked
            |> Map.update(index, MapSet.new([coord]), fn(board) ->
              MapSet.put(board, coord)
            end)
          end)

        if Enum.any?(boards, &bingo?/1) do
          winner = Enum.find(boards, &bingo?/1)

          {:halt, {winner, number}}
        else
          {:cont, boards}
        end
      end)

    winner
    |> unmarked_numbers(locations)
    |> Enum.sum
    |> Kernel.*(number)
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
      ...> |> p2
      1924
  """
  def p2({bingo_balls, locations}) do
  end
end
