defmodule Advent2017.Day17 do
  def spinlock(stop), do: spinlock({0}, 0, stop)
  def spinlock(buffer, position, stop) do
    value = tuple_size(buffer)
    cond do
      value > stop -> buffer
      true ->
        position = rem(position + 394, value)+1
        spinlock(Tuple.insert_at(buffer, position, value), position, stop)
    end
  end

  def p1 do
    buffer =
      spinlock(2017)

    elem(buffer, Enum.find_index(Tuple.to_list(buffer), & &1 == 2017)+1)
  end

  def p2 do
    elem(
      Enum.reduce(1..50_000_000, {0, 0}, fn i, {secondElement, index} ->
        countedTo     = rem((index + 394), i)
        secondElement = if countedTo == 0, do: i, else: secondElement

        {secondElement, countedTo + 1}
      end),
      0)
  end
end
