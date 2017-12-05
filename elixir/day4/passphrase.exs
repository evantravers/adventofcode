defmodule Advent2017 do
  def day4a(line), do: String.split(line, " ", [trim: true])

  def day4b(line) do
    line
    |> String.split(" ", [trim: true])
    |> Enum.map(&Enum.sort(to_charlist(&1)))
  end

  def passphrase(func) do
    {:ok, file} = File.read("input.txt")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(&func.(&1))
    |> Enum.filter(fn (x) -> Enum.count(x) == Enum.count(Enum.uniq(x)) end)
    |> Enum.count
  end

  def run do
    IO.puts "Part 1: #{passphrase(&day4a/1)}"
    IO.puts "Part 2: #{passphrase(&day4b/1)}"
  end
end

Advent2017.run
