defmodule Advent2016.Day5 do
  @moduledoc """
  http://adventofcode.com/2016/day/5
  """

  use Bitwise

  def encrypt(input, number) do
    :crypto.hash(:md5, "#{input}#{number}")
  end

  def matches(input, number) do
    binary_part(encrypt(input, number), 0, 3) <= <<0, 0, 15>>
  end

  def sixth_char(binary, password) do
    index =
      if map_size(password) == 0 do
        0
      else
        (password |> Map.keys |> Enum.max) + 1
      end

    Map.put(password, index,
      binary
        |> Base.encode16
        |> String.graphemes
        |> Enum.at(5)
    )
  end

  @doc """
  The sixth character is the position of the character in the seventh place.
  """
  def magic_char(binary, password) do
    string = binary |> Base.encode16 |> String.graphemes()

    position = Enum.at(string, 5)
    char     = Enum.at(string, 6)

    if Enum.member?(?0..?7, hd(String.to_charlist(position))) do
      Map.put_new(password, position, char)
    else
      password
    end
  end

  def decode(input, next_char, number \\ 0, password \\ %{})
  def decode(_, _, _, password) when map_size(password) == 8 do
    with {_, chars} <- password |> Enum.sort |> Enum.unzip
    do
      chars
      |> Enum.join
      |> String.downcase
    end
  end
  def decode(input, next_char, number, password) do
    if matches(input, number) do
      decode(input, next_char, number + 1, next_char.(encrypt(input, number), password))
    else
      decode(input, next_char, number + 1, password)
    end
  end

  def p1 do
    decode("uqwqemis", &sixth_char/2)
  end

  def p2 do
    decode("uqwqemis", &magic_char/2)
  end
end
