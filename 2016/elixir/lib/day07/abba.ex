defmodule Advent2016.Day7 do
  @moduledoc """
  http://adventofcode.com/2016/day/7
  """

  @doc ~S"""
  An IP supports TLS if it has an Autonomous Bridge Bypass Annotation, or ABBA.
  An ABBA is any four-character sequence which consists of a pair of two
  different characters followed by the reverse of that pair, such as xyyx or
  abba. However, the IP also must not have an ABBA within any hypernet
  sequences, which are contained by square brackets.

      iex> support_tls?("abba[mnop]qrst")
      true
      iex> support_tls?("abcd[bddb]xyyx")
      false
      iex> support_tls?("aaaa[qwer]tyui")
      false
      iex> support_tls?("ioxxoj[asdfgh]zxcvbn")
      true
  """
  def support_tls?(string) do
    string
    |> String.graphemes
    |> scan
  end

  @doc """
  This is basically a reduce, but I like the clarity of writing it myself.
  """
  def scan(chars, tls \\ false)
  def scan([], tls), do: tls
  def scan([char|chars], tls) do
    cond do
      char == "[" ->
        hypernet(chars, tls)

      abba?([char|chars]) ->
        scan(chars, true)

      true ->
        scan(chars, tls)
    end
  end
  def hypernet([char|chars], tls) do
    cond do
      char == "]" ->
        scan(chars, tls)

      abba?([char|chars]) ->
        false

      true ->
        hypernet(chars, tls)
    end
  end

  def abba?(list) when length(list) < 4, do: false
  def abba?([c1, c2, c3, c4]) do
    c1 == c4 && c2 == c3 && c1 != c2
  end
  def abba?(list) do
    abba?(Enum.take(list, 4))
  end

  def p1, do: nil
  def p2, do: nil
end
