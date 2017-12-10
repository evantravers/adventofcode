defmodule Advent2017.Day9 do
  @doc ~S"""
  `expression` needs to go char by char, and fire off recursive functions based on
  the character.

  - "<" starts a garbage string, which listens for the very next ">" character,
    ignoring all "<".
  - "!" cancels the next character.
  - "{" starts a group, which listens for the next "}" to close it. Each level
    gets score+1.

    iex> Advent2017.Day9.process("{}")[:score]
    1
    iex> Advent2017.Day9.process("{{{}}}")[:score]
    6
    iex> Advent2017.Day9.process("{{},{}}")[:score]
    5
    iex> Advent2017.Day9.process("{{{},{},{{}}}}")[:score]
    16
    iex> Advent2017.Day9.process("{<a>,<a>,<a>,<a>}")[:score]
    1
    iex> Advent2017.Day9.process("{{<ab>},{<ab>},{<ab>},{<ab>}}")[:score]
    9
    iex> Advent2017.Day9.process("{{<!!>},{<!!>},{<!!>},{<!!>}}")[:score]
    9
    iex> Advent2017.Day9.process("{{<a!>},{<a!>},{<a!>},{<ab>}}")[:score]
    3
  """
  def process(str) do
    str
    |> String.graphemes
    |> group(%{score: 0, level: 0, garbage: 0})
  end

  def inc(map, key) do
    {_, new_map} =
      Map.get_and_update!(map, key, fn(val) -> {val, val + 1} end)
    new_map
  end

  def dec(map, key) do
    {_, new_map} =
      Map.get_and_update!(map, key, fn(val) -> {val, val - 1} end)
    new_map
  end

  def add_score(map) do
    {_, new_map} =
      Map.get_and_update!(map, :score, fn(score) -> {score, score + map.level} end)
    new_map
  end

  def group([], state), do: state
  def group([char|input], state) do
    # by character
    case char do
      "{" ->
        group(input, inc(state, :level))
      "," ->
        group(input, state)
      "}" ->
        group(input, dec(add_score(state), :level))
      "<" ->
        garbage(input, state)
    end
  end

  def garbage([char|input], state) do
    case char do
      "!" ->
        garbage(tl(input), state) # skip a letter
      ">" ->
        group(input, state)
      _ ->
        garbage(input, inc(state, :garbage)) # count random crap
    end
  end

  def load_file do
    {:ok, file} = File.read("./lib/day9/input.txt")
    file
    |> String.trim
  end

  def p1 do
    load_file()
    |> process
    |> Map.get(:score)
  end

  def p2 do
    load_file()
    |> process
    |> Map.get(:garbage)
  end
end
