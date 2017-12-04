defmodule Advent2017 do
  def day4a do
    {:ok, file} = File.read("input.txt")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(&String.split(&1, " ", [trim: true]))
    |> Enum.filter(fn (x) -> Enum.count(x) == Enum.count(Enum.uniq(x)) end)
    |> Enum.count
  end
end

IO.puts "Part 1: #{Advent2017.day4a}"
