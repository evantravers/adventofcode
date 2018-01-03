defmodule Advent2015.Day5 do
  @moduledoc """
  A nice string is one with all of the following properties:

  It contains at least three vowels (aeiou only), like aei, xazegov, or aeiouaeiouaeiou.
  It contains at least one letter that appears twice in a row, like xx, abcdde (dd), or aabbccdd (aa, bb, cc, or dd).
  It does not contain the strings ab, cd, pq, or xy, even if they are part of one of the other requirements.
  For example:

  ugknbfddgicrmopn is nice because it has at least three vowels (u...i...o...), a double letter (...dd...), and none of the disallowed substrings.
  aaa is nice because it has at least three vowels and a double letter, even though the letters used by different rules overlap.
  jchzalrnumimnmhp is naughty because it has no double letter.
  haegwjzuvuyypxyu is naughty because it contains the string xy.
  dvszwmarrgswjxmb is naughty because it contains only one vowel.
  How many strings are nice?

  Realizing the error of his ways, Santa has switched to a better model of
  determining whether a string is naughty or nice. None of the old rules apply,
  as they are all clearly ridiculous.

  Now, a nice string is one with all of the following properties:

  It contains a pair of any two letters that appears at least twice in the
  string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like
  aaa (aa, but it overlaps).

  It contains at least one letter which repeats
  with exactly one letter between them, like xyx, abcdefeghi (efe), or even
  aaa.
  """

  def load_input do
    {:ok, file} = File.read("#{__DIR__}/input.txt")

    file
    |> String.split("\n", trim: true)
  end

  @doc """
  iex> Advent2015.Day5.nice?("ugknbfddgicrmopn")
  true
  """
  def nice?(str) do
    has_three_vowels(str) and has_double(str) and no_naughty_words(str)
  end

  def has_three_vowels(str) do
    ~r/a|e|i|o|u/
    |> Regex.scan(str)
    |> Enum.count
    |> Kernel.>(2)
  end

  def has_double(str) do
    Regex.match?(~r/(\w)\1/, str)
  end

  def no_naughty_words(str) do
    !Regex.match?(~r/ab|cd|pq|xy/, str)
  end

  def p1 do
    load_input()
    |> Enum.map(&nice? &1)
    |> Enum.filter(& &1)
    |> Enum.count
  end

  @doc ~S"""
      iex> Advent2015.Day5.better_nice("qjhvhtzxzqqjkmpb")
      true
      iex> Advent2015.Day5.better_nice("xxyxx")
      true
      iex> Advent2015.Day5.better_nice("uurcxstgmygtbstg")
      false
      iex> Advent2015.Day5.better_nice("ieodomkazucvgmuy")
      false
  """
  def better_nice(str) do
    has_sandwhich(str) && has_pair(str)
  end

  @doc ~S"""
  It contains a pair of any two letters that appears at least twice in the
  string without overlapping, like xyxy (xy) or aabcdefgaa (aa), but not like
  aaa (aa, but it overlaps)

      iex> Advent2015.Day5.has_pair("xyxy")
      true
      iex> Advent2015.Day5.has_pair("aabcdefgaa")
      true
      iex> Advent2015.Day5.has_pair("aaa")
      false
  """
  def has_pair(str) do
    {return, _} =
      str
      |> String.graphemes
      |> Enum.reduce({false, false}, fn char, {truthy, previous} ->
        if previous do
          foundmatch = ~r/#{previous}#{char}/
                       |> Regex.scan(str)
                       |> Enum.count
                       |> Kernel.>=(2)
          {truthy or foundmatch, char}
        else
          {false, char}
        end
      end)
    return
  end

  @doc ~S"""
  It contains at least one letter which repeats with exactly one letter between
  them, like xyx, abcdefeghi (efe), or even aaa.

      iex> Advent2015.Day5.has_sandwhich("xyx")
      true
      iex> Advent2015.Day5.has_sandwhich("abcdefeghi")
      true
      iex> Advent2015.Day5.has_sandwhich("aaa")
      true
  """
  def has_sandwhich(str) do
    Regex.match?(~r/(\w)\w\1/, str)
  end

  def p2 do
    load_input()
    |> Enum.map(& {&1, better_nice &1})
    |> Enum.filter(fn {_, x} -> x end)
    |> Enum.count
  end
end
