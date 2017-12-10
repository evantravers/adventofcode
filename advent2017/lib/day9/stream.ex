defmodule Advent2017.Day9 do
  @doc ~S"""
    iex> Advent2017.Day9.process("{}")
    1
    iex> Advent2017.Day9.process("{{{}}}")
    6
    iex> Advent2017.Day9.process("{{},{}}")
    5
    iex> Advent2017.Day9.process("{{{},{},{{}}}}")
    16
    iex> Advent2017.Day9.process("{<a>,<a>,<a>,<a>}")
    1
    iex> Advent2017.Day9.process("{{<ab>},{<ab>},{<ab>},{<ab>}}")
    9
    iex> Advent2017.Day9.process("{{<!!>},{<!!>},{<!!>},{<!!>}}")
    9
    iex> Advent2017.Day9.process("{{<a!>},{<a!>},{<a!>},{<ab>}}")
    3
  """
  def process(input) do
    nil
  end
end
