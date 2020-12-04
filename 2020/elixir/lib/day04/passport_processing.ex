defmodule Advent2020.Day4 do
  @moduledoc "https://adventofcode.com/2020/day/4"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n\n", trim: true)
      |> Enum.map(&parse_passport/1)
    end
  end

  @doc """
      # iex> pass_passport("iyr:2013 hcl:#ceb3a1\nhgt:151cm eyr:2030\nbyr:1943 ecl:grn")
      # %{iyr: "2013", hcl: "#ceb3a1", hgt: "151cm", eyr: "2030", byr: "1943", ecl: "grn"}
  """
  def parse_passport(str) do
    str
    |> String.split(~r/\W/)
    |> Enum.reject(&String.length(&1) == 0)
    |> Enum.chunk_every(2)
    |> Enum.reduce(%{}, fn([key, val], passport) -> Map.put(passport, String.to_atom(key), val) end)
  end

  def p1(passports) do
    passports
    |> Enum.count(fn(passport) ->
      [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
      |> Enum.all?(&Map.has_key?(passport, &1))
    end)
  end
  def p2(_i), do: nil
end
