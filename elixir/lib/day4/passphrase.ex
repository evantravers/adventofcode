defmodule Advent2017.Day4 do
  def day4a(line), do: String.split(line, " ", [trim: true])

  def day4b(line) do
    line
    |> String.split(" ", [trim: true])
    |> Enum.map(&Enum.sort(to_charlist(&1)))
  end

  def passphrase(func) do
    {:ok, file} = File.read("./lib/day4/input.txt")

    file
    |> String.split("\n", [trim: true])
    |> Enum.map(&func.(&1))
    |> Enum.filter(fn (x) -> Enum.count(x) == Enum.count(Enum.uniq(x)) end)
    |> Enum.count
  end

  def p1, do: passphrase(&day4a/1)
  def p2, do: passphrase(&day4b/1)
end
