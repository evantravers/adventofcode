defmodule Advent2015.Day4 do
  @moduledoc """
  To do this, he needs to find MD5 hashes which, in hexadecimal, start with at
  least five zeroes. The input to the MD5 hash is some secret key (your puzzle
  input, given below) followed by a number in decimal. To mine AdventCoins, you
  must find Santa the lowest positive number (no leading zeroes: 1, 2, 3, ...)
  that produces such a hash.
  """

  def valid(string) do
    :md5
    |> :crypto.hash(string)
    |> Base.encode16
    |> String.slice(0, 5)
    |> Kernel.==("00000")
  end

  def find_hash(input, number \\ 0) do
    if valid("#{input}#{number}") do
      number
    else
      find_hash(input, number + 1)
    end
  end

  def p1 do
    find_hash("yzbqklnj")
  end

  def p2, do: nil
end
