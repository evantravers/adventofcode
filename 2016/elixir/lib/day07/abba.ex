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
    |> supernet
    |> Map.get(:tls)
  end

  @doc ~S"""
      iex> support_ssl?("aba[bab]xyz")
      true
      iex> support_ssl?("xyx[xyx]xyx")
      false
      iex> support_ssl?("aaa[kek]eke")
      true
      iex> support_ssl?("zazbz[bzb]cdb")
      true
  """
  def support_ssl?(string) do
    string
    |> String.graphemes
    |> supernet
    |> ssl_enabled?
  end

  @doc """
  Expects a finished state (map) with keys for :aba and :bab linked to lists
  of lists of chars.
  """
  def ssl_enabled?(state) do
    state
    |> Map.get(:aba)
    |> Enum.map(fn(element) ->
      Enum.member?(state[:bab], aba_to_bab(element))
    end)
    |> Enum.any?(& &1) # returns true if any of them are true
  end

  def aba_to_bab([a, b, _]), do: [b, a, b]

  @doc """
  This is basically a reduce, but I like the clarity of writing it myself.
  """
  def supernet(chars, state \\ %{tls: false, broken_tls: false, aba: [], bab: []})
  def supernet([], state), do: state
  def supernet([char|chars], state) do
    cond do
      char == "[" ->
        hypernet(chars, state)

      abba?([char|chars]) && !state[:broken_tls] ->
        supernet(chars, %{state | tls: true})

      aba?([char|chars]) ->
        supernet(chars, %{state | aba: [[char|Enum.take(chars, 2)]|state[:aba]]})

      true ->
        supernet(chars, state)
    end
  end
  def hypernet([char|chars], state) do
    cond do
      char == "]" ->
        supernet(chars, state)

      abba?([char|chars]) ->
        hypernet(chars, %{state | tls: false, broken_tls: true})

      aba?([char|chars]) ->
        hypernet(chars, %{state | bab: [[char|Enum.take(chars, 2)]|state[:bab]]})

      true ->
        hypernet(chars, state)
    end
  end

  def abba?(list) when length(list) < 4, do: false
  def abba?([c1, c2, c3, c4]) do
    c1 == c4 && c2 == c3 && c1 != c2
  end
  def abba?(list) do
    abba?(Enum.take(list, 4))
  end

  def aba?(list) when length(list) < 3, do: false
  def aba?([c1, c2, c3]) do
    c1 == c3 && c1 != c2
  end
  def aba?(list) do
    aba?(Enum.take(list, 3))
  end

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input"), do: file
    |> String.split("\n", trim: true)
  end

  def p1 do
    load_input()
    |> Enum.map(&support_tls?/1)
    |> Enum.count(& &1) # testing the truthyness of each element in the list
  end

  def p2 do
    load_input()
    |> Enum.map(&support_ssl?/1)
    |> Enum.count(& &1)
  end
end
