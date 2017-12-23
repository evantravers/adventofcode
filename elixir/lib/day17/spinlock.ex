defmodule Advent2017.Day17 do
  def spinlock(stop), do: spinlock({0}, 0, stop)
  def spinlock(buffer, position, stop) do
    value = tuple_size(buffer)
    if value > stop do
      buffer
    else
      position = rem(position + 394, value) + 1
      spinlock(Tuple.insert_at(buffer, position, value), position, stop)
    end
  end

  def p1 do
    buffer =
      spinlock(2017)

    elem(buffer, Enum.find_index(Tuple.to_list(buffer), & &1 == 2017) + 1)
  end

  def p2 do
    elem(
      Enum.reduce(1..50_000_000, {0, 0}, fn i, {second_element, index} ->
        counted_to     = rem((index + 394), i)
        second_element = if counted_to == 0, do: i, else: second_element

        {second_element, counted_to + 1}
      end),
      0)
  end
end
