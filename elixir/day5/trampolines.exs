defmodule Advent2017 do
  def trampoline(list) do
    trampoline(list, 0, 0)
  end

  def trampoline(list, index, jumps) do
    cond do
      index < 0 ->
        jumps
      is_nil(Enum.at(list, index)) ->
        jumps
      true ->
        value  = Enum.at(list, index)
        offset = index + value

        list
        |> List.replace_at(index, value+1)
        |> trampoline(offset, jumps+1)
    end
  end

  def part1 do
    {:ok, file} = File.read("input.txt")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(&(String.to_integer(&1)))
    |> trampoline
  end
end

IO.puts "Part 1: #{Advent2017.part1()}"
