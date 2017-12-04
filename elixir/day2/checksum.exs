defmodule Advent2017 do

  def find_divisible ([current|tail]) do
    number = Enum.find(tail, fn (item) -> rem(current, item) == 0 end)
    case number do
      nil ->
        find_divisible tail
      _ ->
        {current, number}
    end
  end

  def run do
    {:ok, file} = File.read("input.txt")

    file =
      file
      |> String.split("\n", [trim: true])
      |> Enum.map(
        fn (line) ->
          String.split(line, "\t")
          |> Enum.map(&(String.to_integer(&1)))
        end)

    part1 =
      file
      |> Enum.reduce(0, fn(list, acc) ->
        diff = Enum.max(list) - Enum.min(list)
        acc + diff
      end)

    part2 =
      file
      |> Enum.map(&Enum.sort/1)
      |> Enum.map(&Enum.reverse/1)
      |> Enum.map(&find_divisible/1)
      |> Enum.map(fn({a, b}) -> div(a, b) end)
      |> Enum.sum

    IO.puts part1
    IO.puts part2
  end
end


Advent2017.run
