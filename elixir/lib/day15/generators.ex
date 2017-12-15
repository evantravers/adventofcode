require IEx

defmodule Advent2017.Day15 do
  use Bitwise

  @generatorA 16807
  @generatorB 48271

  @doc ~S"""
      iex> Advent2017.Day15.generate(65, 16807)
      1092455
      iex> Advent2017.Day15.generate(8921, 48271)
      ...> |> Advent2017.Day15.generate(48271)
      1233683848
  """

  def first_sixteen(string), do: String.slice(string, -16..-1)

  @doc ~S"""
      iex> Advent2017.Day15.judge(1181022009, 1233683848)
      false
      iex> Advent2017.Day15.judge(245556042, 1431495498)
      true
   """
  def judge(genA, genB) do
    a =
      genA
      |> Integer.to_string(2)
      |> String.pad_leading(16, "0")

    b =
      genB
      |> Integer.to_string(2)
      |> String.pad_leading(16, "0")

    first_sixteen(a) == first_sixteen(b)
  end

  @doc ~S"""
      iex> Advent2017.Day15.judge_bitwise(1181022009, 1233683848)
      false
      iex> Advent2017.Day15.judge_bitwise(245556042, 1431495498)
      true
   """
  def judge_bitwise(genA, genB) do
    '0000000000000000' ==
      genA ^^^ genB
      |> Integer.to_charlist(2)
      |> Enum.slice(-16..-1)
  end

  def generate(previous, factor) do
    rem(previous * factor, 2147483647)
  end

  def p1, do: p1(65, 8921, 0, 0)
  def p1(_, _, 40_000_000, score), do: score
  def p1(a, b, count, score) do
    a = generate(a, @generatorA)
    b = generate(b, @generatorB)

    case judge_bitwise(a, b) do
      true  -> p1(a, b, count+1, score+1)
      false -> p1(a, b, count+1, score)
    end
  end
end
