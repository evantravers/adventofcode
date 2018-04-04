defmodule Advent2016.Day5 do
  @moduledoc """
  http://adventofcode.com/2016/day/5
  """

  use Bitwise
  @input "uqwqemis"

  def encrypt(input, number) do
    :crypto.hash(:md5, "#{input}#{number}")
  end

  def matches(input, number) do
    binary_part(encrypt(input, number), 0, 3) <= <<0, 0, 15>>
  end

  def sixth_char(binary) do
    binary
    |> Base.encode16
    |> String.graphemes
    |> Enum.at(5)
  end

  def decode(input, number \\ 0, password \\ [])
  def decode(_, _, password) when length(password) == 8 do
    password |> Enum.reverse |> Enum.join
  end
  def decode(input, number, password) do
    if matches(input, number) do
      decode(input, number + 1, [sixth_char(encrypt(input, number)) | password])
    else
      decode(input, number + 1, password)
    end
  end

  def p1 do
    decode(@input)
  end

  def p2 do
  end
end
