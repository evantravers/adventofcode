defmodule Advent2017.Day17 do
  def spinlock(steps), do: spinlock({0}, 0, steps)
  def spinlock(buffer, _, _) when tuple_size(buffer)>2017, do: buffer
  def spinlock(buffer, position, steps) do
    position = rem(position + steps, tuple_size(buffer))+1
    value    = tuple_size(buffer)
    spinlock(Tuple.insert_at(buffer, position, value), position, steps)
  end

  def p1 do
    buffer =
      spinlock(394)

    elem(buffer, Enum.find_index(Tuple.to_list(buffer), & &1 == 2017)+1)
  end
end
