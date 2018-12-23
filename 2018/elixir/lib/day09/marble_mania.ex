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
    ```

    can become...

    ```
    {[], [1, 2, 3, 4, 5, 6, 7, 8]}
    {[8, 7, 6, 5], [1, 2, 3, 4]}
    {[8, 7, 6, 5, 4, 3, 2, 1], []}
    ```
    """
    def to_list({l, r}), do: Enum.concat(r, Enum.reverse(l))
    def to_circle(list), do: {[], list}

    @doc """
    Turns the circle clockwise.
    """
    def clockwise({l, []}), do: {[], Enum.reverse(l)} |> clockwise
    def clockwise({l, [r_head|r]}), do: {[r_head|l], r}

    @doc """
    inversion of clockwise...
    """
    def counterclockwise(circle, 0), do: circle
    def counterclockwise(circle, num) do
      counterclockwise(counterclockwise(circle, num - 1))
    end
    def counterclockwise({[], r}), do: {Enum.reverse(r), []} |> counterclockwise
    def counterclockwise({[l_head|l], r}), do: {l, [l_head|r]}


    def current({_, [current|_]}), do: current
    def remove_current({l, [_|r]}), do: {l, r}

    @doc """
    Then, each Elf takes a turn placing the lowest-numbered remaining marble
    into the circle between the marbles that are 1 and 2 marbles clockwise of
    the current marble.
    """
    def insert(circle, marble) do
      circle
      |> clockwise
      |> clockwise
      |> (fn ({l, r}) -> {l, [marble|r]} end).()
    end

    def print_circle(circle) do
      circle
      |> Circle.to_list
      |> (fn ([head|tail]) -> ["(#{head})"|tail] end).()
      |> Enum.join(" ")
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

      iex> play_game(9, 25) |> Map.values |> Enum.max
      32
      iex> play_game(10, 1618) |> Map.values |> Enum.max
      8317
      iex> play_game(13, 7999) |> Map.values |> Enum.max
      146373
      iex> play_game(17, 1104) |> Map.values |> Enum.max
      2764
      iex> play_game(21, 6111) |> Map.values |> Enum.max
      54718
      iex> play_game(30, 5807) |> Map.values |> Enum.max
      37305

  I add +2 to last_marble because the current_marble stops when it ==
  last_marble, so it needs to be at least one more, and because current_marble
  starts at 1
  """
  def play_game(players, last_marble) do
    [0]
    |> Circle.to_circle
    |> play(setup_scoreboard(players), last_marble + 2)
  end

  def play(board, players, last_marble, current_marble \\ 1)
  def play(_, players, last_marble, last_marble), do: players
  def play(board, players, last_marble, current_marble) do
    current_player = Integer.mod(current_marble - 1, Enum.count(players))
    # IO.puts("[#{current_player}] #{Circle.print_circle(board)}")
    if Integer.mod(current_marble, 23) == 0 do
      # current_player = Integer.mod(current_marble - 1, Enum.count(players))
      score          = board
                       |> Circle.counterclockwise(7)
                       |> Circle.current
                       |> Kernel.+(current_marble)


      play(
        Circle.counterclockwise(board, 7) |> Circle.remove_current,
        Map.update!(players, current_player, & &1 + score),
        last_marble,
        current_marble + 1
      )
    else
      play(
        Circle.insert(board, current_marble),
        players,
        last_marble,
        current_marble + 1
      )
    end
  end

  def setup_scoreboard(players) do
    for player <- 0..players-1, into: %{}, do: {player, 0}
  end

  def p1 do
    {players, last_marble} = load_input()

    players
    |> play_game(last_marble)
    |> Map.values
    |> Enum.max
  end

  def p2 do
    {players, last_marble} = load_input()

    players
    |> play_game(last_marble * 100)
    |> Map.values
    |> Enum.max
  end
end
