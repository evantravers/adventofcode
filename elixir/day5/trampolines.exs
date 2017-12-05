defmodule Advent2017 do
  def trampoline(list) do
    trampoline(list, 0, 0)
  end

  def trampoline(list, index, jumps) do
    cond do
      index < 0 ->
        jumps
      index >= tuple_size(list) ->
        jumps
      true ->
        value  = elem(list, index)
        offset = index + value

        list
        |> put_elem(index, value+1)
        |> trampoline(offset, jumps+1)
    end
  end

  def stranger(list, index, jumps) do
    # list
    # |> Tuple.to_list
    # |> Enum.with_index
    # |> Enum.map(fn ({item, i}) -> 
    #   IO.binwrite if i == index, do: "_", else: " "
    #   IO.binwrite Integer.to_string(item)
    #   IO.binwrite if i == index, do: "_", else: " "
    # end)
    # IO.puts "\n"

    cond do
      index < 0 ->
        jumps
      index >= tuple_size(list) ->
        jumps
      true ->
        value  = elem(list, index)
        offset = index + value
        inc =
          if value >= 3, do: -1, else: 1

        list
        |> put_elem(index, value+inc)
        |> stranger(offset, jumps+1)
    end
  end

  def part1 do
    {:ok, file} = File.read("input.txt")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(&(String.to_integer(&1)))
    |> List.to_tuple
    |> trampoline
  end

  def part2 do
    {:ok, file} = File.read("input.txt")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(&(String.to_integer(&1)))
    |> List.to_tuple
    |> stranger(0, 0)
  end
end

IO.puts "Part 1: #{Advent2017.part1()}"
IO.puts "Part 2: #{Advent2017.part2()}"
