defmodule Advent2015.Day3 do
  @moduledoc """
  He begins by delivering a present to the house at his starting location, and
  then an elf at the North Pole calls him via radio and tells him where to move
  next. Moves are always exactly one house to the north (^), south (v), east
  (>), or west (<). After each move, he delivers another present to the house
  at his new location.

  However, the elf back at the north pole has had a little too much eggnog, and
  so his directions are a little off, and Santa ends up visiting some houses
  more than once. How many houses receive at least one present?

  The next year, to speed up the process, Santa creates a robot version of
  himself, Robo-Santa, to deliver presents with him.

  Santa and Robo-Santa start at the same location (delivering two presents to
  the same starting house), then take turns moving based on instructions from
  the elf, who is eggnoggedly reading from the same script as the previous
  year.
  """
  def load_input do
    {:ok, file} = File.read("#{__DIR__}/input.txt")

    file
    |> String.graphemes
  end

  def u({x, y}), do: {x, y + 1}
  def r({x, y}), do: {x + 1, y}
  def d({x, y}), do: {x, y - 1}
  def l({x, y}), do: {x - 1, y}

  def sleighride([], history), do: history
  def sleighride([direction|instructions], history \\ [{0, 0}]) do
    last_position = hd history
    case direction do
      "^" -> sleighride(instructions, [u(last_position)|history])
      ">" -> sleighride(instructions, [r(last_position)|history])
      "v" -> sleighride(instructions, [d(last_position)|history])
      "<" -> sleighride(instructions, [l(last_position)|history])
    end
  end

  def count_houses(history) do
    history
    |> Enum.uniq
    |> Enum.count
  end

  def p1 do
    load_input()
    |> sleighride
    |> count_houses
  end

  def p2 do
    instructions = load_input()
    santa        = Enum.take_every(instructions, 2)
    robosanta    = Enum.take_every(tl(instructions), 2)

    sleighride(santa) ++ sleighride(robosanta)
    |> count_houses
  end
end
