defmodule Advent2018.Day13 do
  @moduledoc "https://adventofcode.com/2018/day/13"

  def load_file(input) do
    with {:ok, file} <- File.read("#{__DIR__}/#{input}") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)
    end
  end

  def load_input(input \\ "input.txt") do
    input
    |> load_file
    |> load_track
    |> load_cars
  end

  def load_track(list_of_lists) do
    for {row, y} <- Enum.with_index(list_of_lists),
        {character, x} <- Enum.with_index(row),
        character != " ",
        into: %{} do
      {{x, y}, character}
    end
  end

  def load_cars(map) do
    cars =
      map
      |> Enum.filter(fn({_, val}) -> val =~ ~r/v|\^|\<|\>/ end)
      |> Enum.map(&initialize_car/1)

    {cars, Enum.into(Enum.map(map, &replace_cars_with_track/1), %{})}
  end

  def initialize_car({{x, y}, character}) do
    %{pos: {x, y}, direction: char_to_dir(character), next_turn: :left}
  end

  def turn_order(c = %{next_turn: :left}), do: %{c | next_turn: :straight}
  def turn_order(c = %{next_turn: :straight}), do: %{c | next_turn: :right}
  def turn_order(c = %{next_turn: :right}), do: %{c | next_turn: :left}

  def char_to_dir("v"), do: :south
  def char_to_dir("^"), do: :north
  def char_to_dir(">"), do: :east
  def char_to_dir("<"), do: :west

  def dir_to_char(:south), do: "v"
  def dir_to_char(:north), do: "^"
  def dir_to_char(:east), do: ">"
  def dir_to_char(:west), do: "<"

  def replace_cars_with_track({coord, "^"}), do: {coord, "|"}
  def replace_cars_with_track({coord, "v"}), do: {coord, "|"}
  def replace_cars_with_track({coord, ">"}), do: {coord, "-"}
  def replace_cars_with_track({coord, "<"}), do: {coord, "-"}
  def replace_cars_with_track(anything), do: anything

  def move(c = %{pos: {x, y}, direction: :north}), do: %{c | pos: {x, y - 1}}
  def move(c = %{pos: {x, y}, direction: :south}), do: %{c | pos: {x, y + 1}}
  def move(c = %{pos: {x, y}, direction: :east}),  do: %{c | pos: {x + 1, y}}
  def move(c = %{pos: {x, y}, direction: :west}),  do: %{c | pos: {x - 1, y}}

  def turn(c, :straight), do: c # no action

  def turn(c = %{direction: :north}, :left), do: %{c | direction: :west}
  def turn(c = %{direction: :south}, :left), do: %{c | direction: :east}
  def turn(c = %{direction: :east}, :left),  do: %{c | direction: :north}
  def turn(c = %{direction: :west}, :left),  do: %{c | direction: :south}

  def turn(c = %{direction: :north}, :right), do: %{c | direction: :east}
  def turn(c = %{direction: :south}, :right), do: %{c | direction: :west}
  def turn(c = %{direction: :east}, :right),  do: %{c | direction: :south}
  def turn(c = %{direction: :west}, :right),  do: %{c | direction: :north}

  def horizontal?(%{direction: dir}), do: Enum.member?([:east, :west], dir)
  def vertical?(%{direction: dir}), do: Enum.member?([:north, :south], dir)

  def next_position(car, track) do
    car
    |> move
    |> next_orientation(track)
  end

  def next_orientation(car, track) do
    case Map.get(track, car.pos) do
      "\\" -> if horizontal?(car), do: turn(car, :right), else: turn(car, :left)
      "/"  -> if horizontal?(car), do: turn(car, :left), else: turn(car, :right)
      "+"  -> car |> turn(car.next_turn) |> turn_order
      _ -> car
    end
  end

  def tick({cars, track}) do
    {
      Enum.map(cars, &next_position(&1, track)),
      track
    }
  end

  def print_track({cars, track}) do
    max_x =
      track
      |> Map.keys
      |> Enum.max_by(&elem(&1, 0))
      |> elem(0)
    max_y =
      track
      |> Map.keys
      |> Enum.max_by(&elem(&1, 1))
      |> elem(1)

    for y <- 0..max_y do
      for x <- 0..max_x do
        car = Enum.find(cars, fn(%{pos: pos}) -> pos == {x, y} end)
        if car do
          dir_to_char(car.direction)
        else
          Map.get(track, {x, y}, " ")
        end
      end
      |> Enum.join
      |> Kernel.<>("\n")
    end
    |> Enum.join
    |> IO.puts
  end

  def p1 do
    load_input()
  end

  def p2, do: nil
end
