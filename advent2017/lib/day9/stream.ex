defmodule Advent2017.Day9 do
  @doc ~S"""
  `process` needs to go char by char, and fire off recursive functions based on
  the character.

  - "<" starts a garbage string, which listens for the very next ">" character,
    ignoring all "<".
  - "!" cancels the next character.
  - "{" starts a group, which listens for the next "}" to close it. Each level
    gets score+1.

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
  def process([char|input]) do
    # by character
    cond do
      "!" ->
        process(input, state)
      "{" ->
        group(input, state)
      "<" ->
        garbage(input, state)
    end
  end
end
