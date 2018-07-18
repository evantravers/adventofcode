defmodule Advent2017.Day15 do
  @moduledoc """
  Here, you encounter a pair of dueling generators. The generators, called
  generator A and generator B, are trying to agree on a sequence of numbers.
  However, one of them is malfunctioning, and so the sequences don't always
  match.

  As they do this, a judge waits for each of them to generate its next value,
  compares the lowest 16 bits of both values, and keeps track of the number of
  times those parts of the values match.

  The generators both work on the same principle. To create its next value, a
  generator will take the previous value it produced, multiply it by a factor
  (generator A uses 16807; generator B uses 48271), and then keep the remainder
  of dividing that resulting product by 2147483647. That final remainder is the
  value it produces next.

  To calculate each generator's first value, it instead uses a specific
  starting value as its "previous value" (as listed in your puzzle input).
  """
  use Bitwise

  @generator_a 16_807
  @generator_b 48_271

  def first_sixteen(string), do: Enum.slice(string, -16..-1)


  @doc ~S"""
      iex> judge(1181022009, 1233683848)
      false
      iex> judge(245556042, 1431495498)
      true
   """
  def judge(genA, genB) do
    (genA &&& 0xffff) == (genB &&& 0xffff)
  end


  @doc ~S"""
      iex> generate(65, 16807)
      1092455
      iex> generate(8921, 48271)
      ...> |> generate(48271)
      1233683848

      iex> generate(65, 16807, &rem(&1, 4)==0)
      1352636452
      iex> generate(8921, 48271, &rem(&1, 8)==0)
      ...> |> generate(48271, &rem(&1, 8)==0)
      862516352
  """
  def generate(previous, factor, comparison \\ fn (_) -> true end) do
    val = rem(previous * factor, 2_147_483_647)
    if comparison.(val) do
      val
    else
      generate(val, factor, comparison)
    end
  end

  def p1, do: p1(783, 325, 40_000_000, 0)
  def p1(_, _, 0, score), do: score
  def p1(a, b, count, score) do
    a = generate(a, @generator_a)
    b = generate(b, @generator_b)

    case judge(a, b) do
      true  -> p1(a, b, count - 1, score + 1)
      false -> p1(a, b, count - 1, score)
    end
  end

  def p2, do: p2(783, 325, 5_000_000, 0)
  def p2(_, _, 0, score), do: score
  def p2(a, b, count, score) do
    a = generate(a, @generator_a, & rem(&1, 4) == 0)
    b = generate(b, @generator_b, & rem(&1, 8) == 0)

    case judge(a, b) do
      true  -> p2(a, b, count - 1, score + 1)
      false -> p2(a, b, count - 1, score)
    end
  end
end
