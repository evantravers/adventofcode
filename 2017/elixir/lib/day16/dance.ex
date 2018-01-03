defmodule Advent2017.Day16 do
  @doc """
  Spin, written sX, makes X programs move from the end to the front, but
  maintain their order otherwise. (For example, s3 on abcde produces cdeab).

      iex> Advent2017.Day16.s("abcde", 3)
      "cdeab"
  """
  def s(string, 0), do: string
  def s(string, count) do
    [last|string] =
      string
      |> String.graphemes
      |> Enum.reverse

    string =
      string ++ [last]
      |> Enum.reverse
      |> Enum.join

    s(string, count-1)
  end

  @doc """
  Exchange, written xA/B, makes the programs at positions A and B swap places.

      iex> Advent2017.Day16.x("abcde", 0, 2)
      "cbade"
  """
  def x(string, pos1, pos2) do
    string
    |> String.graphemes
    |> List.replace_at(pos1, String.at(string, pos2))
    |> List.replace_at(pos2, String.at(string, pos1))
    |> Enum.join
  end

  @doc """
  Partner, written pA/B, makes the programs named A and B swap places.

      iex> Advent2017.Day16.p("abcde", "b", "d")
      "adcbe"
  """
  def p(string, a, b) do
    string
    |> String.graphemes
    |> Enum.map(fn x ->
      cond do
        x == a -> b
        x == b -> a
        true   -> x
      end
    end)
    |> Enum.join
  end

  @doc """
      iex> Advent2017.Day16.dance(["s1", "x3/4", "pe/b"], "abcde")
      "baedc"

      iex> Advent2017.Day16.dance(["s1", "x3/4", "pe/b"], "baedc")
      "ceadb"
  """
  def dance([], dancers), do: dancers
  def dance([instruction|instructions], dancers) do
    case String.at(instruction, 0) do
      "s" ->
        [amount] = Regex.run(~r/\d+/, instruction)
        dance(instructions, s(dancers, String.to_integer(amount)))
      "x" ->
        [_, pos1, pos2] = Regex.run(~r/(\d+)\/(\d+)/, instruction)
        dance(instructions, x(dancers, String.to_integer(pos1), String.to_integer(pos2)))
      "p" ->
        [_, a, b] = Regex.run(~r/(.)\/(.)/, instruction)
        dance(instructions, p(dancers, a, b))
    end
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    file
    |> String.split(",")
    |> dance("abcdefghijklmnop")
  end

  def p2 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    loop =
      file
      |> String.split(",")
      |> find_period("abcdefghijklmnop", [])

    period = length(loop)

    Enum.at(loop, rem(1_000_000_000, period))
  end

  def find_period(instructions, dancers, visited) do
    cond do
      Enum.member? visited, dancers -> Enum.reverse(visited)
      true -> find_period(instructions, dance(instructions, dancers), [dancers|visited])
    end
  end
end
