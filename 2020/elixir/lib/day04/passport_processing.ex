defmodule Advent2020.Day4 do
  @moduledoc "https://adventofcode.com/2020/day/4"

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n\n", trim: true)
      |> Enum.map(&parse_passport/1)
      |> Enum.filter(fn(passport) ->
        [:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid]
        |> Enum.all?(&Map.has_key?(passport, &1))
      end)
    end
  end

  @doc """
      # iex> pass_passport("iyr:2013 hcl:#ceb3a1\nhgt:151cm eyr:2030\nbyr:1943 ecl:grn")
      # %{iyr: "2013", hcl: "#ceb3a1", hgt: "151cm", eyr: "2030", byr: "1943", ecl: "grn"}
  """
  def parse_passport(str) do
    str
    |> String.split(~r/\s|:/)
    |> Enum.reject(&String.length(&1) == 0)
    |> Enum.chunk_every(2)
    |> Enum.reduce(%{}, fn([key, val], passport) -> t(passport, key, val) end)
  end

  def t(passport, "byr" = k, v), do: Map.put(passport, String.to_atom(k), String.to_integer(v))
  def t(passport, "iyr" = k, v), do: Map.put(passport, String.to_atom(k), String.to_integer(v))
  def t(passport, "eyr" = k, v), do: Map.put(passport, String.to_atom(k), String.to_integer(v))
  def t(passport, k, v), do: Map.put(passport, String.to_atom(k), v)

  def p1(passports), do: Enum.count(passports)

  # byr (Birth Year) - four digits; at least 1920 and at most 2002.
  def valid?({:byr, year}), do: Enum.member?(1920..2002, year)
  # iyr (Issue Year) - four digits; at least 2010 and at most 2020.
  def valid?({:iyr, year}), do: Enum.member?(2010..2020, year)
  # eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
  def valid?({:eyr, year}), do: Enum.member?(2020..2030, year)
  # hgt (Height) - a number followed by either cm or in:
  def valid?({:hgt, str}) do
    if Regex.match?(~r/(\d+)(in|cm)/, str) do
      [[_, num, unit]] = Regex.scan(~r/(\d+)(in|cm)/, str)
      valid_height?(unit, num)
    else
      false
    end
  end
  # hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
  def valid?({:hcl, color}), do: Regex.match?(~r/#[0-9a-f]{6}/, color)
  # ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
  def valid?({:ecl, color}), do: Enum.member?(["amb", "blu", "brn", "gry", "grn", "hzl", "oth"], color)
  # pid (Passport ID) - a nine-digit number, including leading zeroes.
  def valid?({:pid, id}), do: String.match?(id, ~r/\d+/) && String.length(id) == 9
  # cid (Country ID) - ignored, missing or not.
  def valid?(_other), do: true

  # If cm, the number must be at least 150 and at most 193.
  def valid_height?("cm", num), do: Enum.member?(150..193, String.to_integer(num))
  # If in, the number must be at least 59 and at most 76.
  def valid_height?("in", num), do: Enum.member?(59..76, String.to_integer(num))

  @doc """
      iex> "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980 hcl:#623a2f"
      ...> |> parse_passport
      ...> |> valid_passport?
      true

      # iex> "hgt:59cm ecl:zzz eyr:2038 hcl:74454a iyr:2023 pid:3556412378 byr:2007"
      # ...> |> parse_passport
      # ...> |> valid_passport?
      # false
  """
  def valid_passport?(passport) do
    passport
    |> Enum.to_list
    |> Enum.all?(&valid?/1)
  end

  def p2(passports), do: Enum.count(passports, &valid_passport?/1)
end
