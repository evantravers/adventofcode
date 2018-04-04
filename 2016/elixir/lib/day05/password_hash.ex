defmodule Advent2016.Day5 do
  @moduledoc """
  http://adventofcode.com/2016/day/5
  """

  @input "uqwqemis"

  def encrypt(input, number) do
    Base.encode16(:crypto.hash(:md5, "#{input}#{number}"))
  end

  def matches(input, number) do
    # I feel like there's a way to do this with <<0, 0, 15>>...
    encrypt(input, number) =~ ~r/^00000/
  end

  def sixth_char(str) do
    str
    |> String.graphemes
    |> Enum.at(5)
  end

  def decode(input, number \\ 0, password \\ [])
  def decode(_, _, password) when length(password) == 8 do
    password
    |> Enum.reverse
    |> Enum.join
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
