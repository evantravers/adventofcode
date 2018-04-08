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
  end

  def p1, do: nil
  def p2, do: nil
end
