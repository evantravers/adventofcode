defmodule Advent2017.Day17 do
  def spinlock(stop), do: spinlock({0}, 0, stop)
  def spinlock(buffer, position, stop) do
    cond do
      tuple_size(buffer) > stop -> buffer
      true ->
        position = rem(position + 394, tuple_size(buffer))+1
        value    = tuple_size(buffer)
        spinlock(Tuple.insert_at(buffer, position, value), position, stop)
    end
  end

  def p1 do
    buffer =
      spinlock(2017)

    elem(buffer, Enum.find_index(Tuple.to_list(buffer), & &1 == 2017)+1)
  end
end
