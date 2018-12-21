defmodule Advent2018.Day9 do
  @moduledoc """
  https://adventofcode.com/2018/day/9

  Pretty sure that this circle of marbles can be implemented as a zipper...

  {[0], []}
  {[0], [1]}
  """

  defmodule Circle do
    @moduledoc """
    Implementing the functions to represent a circle as a tuple of lists... a
    zipper.

    In order to easily go clockwise or counterclockwise, you have to have two
    lists with one reversed.

    Because most of the time, we are going clockwise putting down marbles, I'll
    have the hd of the r list be the "current" marble.

    ```
        (1)
      8     2
    7         3
      6     4
         5

    {[8, 7, 6, 5], [1, 2, 3, 4]}
    ```
    """
    def to_list({l, r}), do: Enum.concat(r, Enum.reverse(l))
    def to_circle(list), do: {[], list}

    @doc """
    Turns the circle clockwise.
    """
    def clockwise({l, []}), do: {[], Enum.reverse(l)}
    def clockwise({l, [r_head|r]}), do: {[r_head|l], r}

    @doc """
    Turns the circle counterclockwise
    """
    def counterclockwise({[], r}), do: {Enum.reverse(r), []}
    def counterclockwise({[l_head|l], r}), do: {l, [l_head|r]}

    def current({_, [current|_]}), do: current

    @doc """
    Then, each Elf takes a turn placing the lowest-numbered remaining marble
    into the circle between the marbles that are 1 and 2 marbles clockwise of
    the current marble.
    """
    def insert(circle, marble) do
      circle
      |> clockwise
      # |> (fn ({l, [r]}) -> {l, [marble|r]} end).()
    end
  end

  def load_input() do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      ~r/\d+/
        |> Regex.scan(file)
        |> List.flatten
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple
    end
  end

  @doc """
  First, the marble numbered 0 is placed in the circle. At this point, while it
  contains only a single marble, it is still a circle: the marble is both
  clockwise from itself and counter-clockwise from itself. This marble is
  designated the current marble.

  Then, each Elf takes a turn placing the lowest-numbered remaining marble into
  the circle between the marbles that are 1 and 2 marbles clockwise of the
  current marble. (When the circle is large enough, this means that there is
    one marble between the marble that was just placed and the current marble.)
  The marble that was just placed then becomes the current marble.

  However, if the marble that is about to be placed has a number which is a
  multiple of 23, something entirely different happens. First, the current
  player keeps the marble they would have placed, adding it to their score.  In
  addition, the marble 7 marbles counter-clockwise from the current marble is
  removed from the circle and also added to the current player's score.  The
  marble located immediately clockwise of the marble that was removed becomes
  the new current marble.

      iex> play(9, 25)
      32
      iex> play(10, 1618)
      8317
      iex> play(13, 7999)
      146373
      iex> play(17, 1104)
      2764
      iex> play(21, 6111)
      54718
      iex> play(30, 5807)
      37305
  """
  def play(players, last_marble) do
    {[0], []}
  end

  def p1 do
    {players, last_marble} = load_input()
  end

  def p2, do: nil
end
