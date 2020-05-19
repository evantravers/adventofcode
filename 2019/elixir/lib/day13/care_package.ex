defmodule Advent2019.Day13 do
  @moduledoc "https://adventofcode.com/2019/day/13"

  def setup do
    with {:ok, intcode} <- File.read("#{__DIR__}/input.txt"), do: intcode
  end

  defmodule Joystick do
    @moduledoc """
    The arcade cabinet has a joystick that can move left and right. The
    software reads the position of the joystick with input instructions:

    If the joystick is in the neutral position, provide 0.
    If the joystick is tilted to the left, provide -1.
    If the joystick is tilted to the right, provide 1.
    """

    def user(joystick) do
      :stdio
      |> IO.stream(1)
      |> Enum.map(fn(char) ->
        case char do
          "l" -> right(joystick) |> IO.inspect
          "h" -> left(joystick) |> IO.inspect
        end
      end)
    end

    defstruct position: :neutral

    def left(%{position: :neutral} = joy), do: %{joy | position: :left}
    def left(%{position: :right}   = joy), do: %{joy | position: :neutral}
    def left(%{position: :left}    = joy), do: %{joy | position: :left}

    def right(%{position: :neutral} = joy), do: %{joy | position: :right}
    def right(%{position: :left}    = joy), do: %{joy | position: :neutral}
    def right(%{position: :right}   = joy), do: %{joy | position: :right}

    def signal(%{position: :right}),   do: 1
    def signal(%{position: :neutral}), do: 0
    def signal(%{position: :left}),    do: -1
  end

  defmodule Game do
    @moduledoc nil

    defstruct tiles: %{}, score: 0

    @spec read_input(list(integer)) :: map()
    @doc """
        iex> read_input([1,2,3,6,5,4])
        %{{1, 2} => :paddle, {6, 5} => :ball}
    """
    def read_input(list_of_int) do
      list_of_int
      |> Enum.chunk_every(3)
      |> Enum.reduce(%Game{}, fn([x, y, id], game) ->
        tiles = Map.get(game, :tiles)

        # only run the display when there's an update so setup is "free"
        if Map.has_key?(tiles, {x, y}) do
          display(game)
        end

        if {x, y} == {-1, 0} do
          Map.put(game, :score, id)
        else
          Map.update!(game, :tiles, fn(tiles) ->
            Map.put(tiles, {x, y}, id_to_object(id))
          end)
        end
      end)
    end

    def score_display(score) do
      length =
        score
        |> Integer.digits
        |> Enum.count

      "᠅᠁#{String.pad_trailing("", length, "᠁")}᠁᠅\n" <>
      "⁞ #{score} ⁞\n" <>
      "᠅᠁#{String.pad_trailing("", length, "᠁")}᠁᠅"
    end

    defp by_coord_value({x, _y}, :x), do: x
    defp by_coord_value({_x, y}, :y), do: y
    def display(game) do
      tiles = Map.get(game, :tiles)
      score = Map.get(game, :score, 0)

      unless Enum.empty?(tiles) do
        coords = Map.keys(tiles)
        {x_0, x_n} =
          coords
          |> Enum.map(&by_coord_value(&1, :x))
          |> Enum.min_max
        {y_0, y_n} = 
          coords
          |> Enum.map(&by_coord_value(&1, :y))
          |> Enum.min_max

        game_display =
          for y <- y_0..y_n do
            for x <- x_0..x_n do
              case Map.get(tiles, {x, y}) do
                :paddle -> "╤"
                :ball   -> "○"
                :block  -> "♡"
                :wall   -> "█"
                _ -> " "
              end
            end
            |> Enum.join("")
          end
          |> Enum.join("\n")

        [score_display(score), '\n', game_display]
        |> IO.puts
        IO.puts(IO.ANSI.clear())
      end
    end

    defp id_to_object(0), do: nil
    defp id_to_object(1), do: :wall
    defp id_to_object(2), do: :block
    defp id_to_object(3), do: :paddle
    defp id_to_object(4), do: :ball
  end

  def p1(source_code) do
    source_code
    |> Intcode.load_string
    |> Intcode.start
    |> Map.get(:output)
    |> Enum.reverse
    |> Game.read_input
    |> Map.get(:tiles)
    |> Enum.filter(fn({_coord, type}) -> type == :block end)
    |> Enum.count
  end

  def p2(source_code) do
    source_code
    |> Intcode.load_string
    |> Intcode.set_memory(0, 2) # put in your quarters
    |> Intcode.start
    |> Map.get(:output)
    |> Enum.reverse
    |> Game.read_input
    |> Map.get(:score)
  end
end
