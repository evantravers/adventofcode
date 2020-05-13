defmodule Advent2019.Day11 do
  @moduledoc "https://adventofcode.com/2019/day/11"
  @behaviour Advent

  def setup do
    with {:ok, intcode_string} <- File.read("#{__DIR__}/input.txt") do
      intcode_string
    end
  end

  defmodule Robot do
    @moduledoc """
    The robot starts facing up.

    The robot's camera provide 0 if the robot is over a black panel or 1 if the
    robot is over a white panel. Then, the program will output two values:

    - First, it will output a value indicating the color to paint the panel the
      robot is over: 0 means to paint the panel black, and 1 means to paint the
      panel white.

    - Second, it will output a value indicating the direction the robot should
      turn: 0 means it should turn left 90 degrees, and 1 means it should turn
      right 90 degrees.

    After the robot turns, it should always move forward exactly one panel.
    """

    defstruct position: {0, 0}, orientation: :U, map: %{}, computer: nil

    def run(%{map: map, position: coord, computer: pid} = robot) do
      if Intcode.halted?(pid) do
        robot
      else
        # read the current square. Default is black.
        camera_image = read_camera(map, coord)

        # provide the signal to the computer
        Intcode.send_input(pid, camera_image)

        # get paint color and turn direction, using hd in disgusting ways
        with state <- Intcode.state(pid),
             output <- Map.get(state, :output),
             [dir_num | [color_num | _]] <- output do
          robot
          |> paint(color_num)
          |> turn(direction(dir_num))
          |> advance
          |> run
        end
      end
    end

    def read_camera(map, coord), do: camera_signal(Map.get(map, coord, :black))

    def camera_signal(:black), do: 0
    def camera_signal(:white), do: 1

    def direction(0), do: :left
    def direction(1), do: :right

    def paint(%{map: map, position: coord} = robot, 1) do
      %{robot | map: Map.put(map, coord, :white)}
    end
    def paint(%{map: map, position: coord} = robot, 0) do
      %{robot | map: Map.put(map, coord, :black)}
    end

    def advance(%{position: {x, y}, orientation: :U} = robot) do
      %{robot | position: {x, y+1}}
    end
    def advance(%{position: {x, y}, orientation: :D} = robot) do
      %{robot | position: {x, y-1}}
    end
    def advance(%{position: {x, y}, orientation: :L} = robot) do
      %{robot | position: {x-1, y}}
    end
    def advance(%{position: {x, y}, orientation: :R} = robot) do
      %{robot | position: {x+1, y}}
    end

    def turn(%{orientation: :U} = robot, :left), do: %{robot | orientation: :L}
    def turn(%{orientation: :L} = robot, :left), do: %{robot | orientation: :D}
    def turn(%{orientation: :D} = robot, :left), do: %{robot | orientation: :R}
    def turn(%{orientation: :R} = robot, :left), do: %{robot | orientation: :U}

    def turn(%{orientation: :U} = robot, :right), do: %{robot | orientation: :R}
    def turn(%{orientation: :R} = robot, :right), do: %{robot | orientation: :D}
    def turn(%{orientation: :D} = robot, :right), do: %{robot | orientation: :L}
    def turn(%{orientation: :L} = robot, :right), do: %{robot | orientation: :U}
  end

  def display_image(map) do
    {x_0, x_n} =
      map
      |> Map.keys
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max

    {y_0, y_n} =
      map
      |> Map.keys
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max

    for y <- y_0..y_n do
      for x <- x_0..x_n do
        if Map.get(map, {x, y}) == :white do
          "█"
        else
          " "
        end
      end
      |> Enum.join("")
    end
    |> Enum.reverse
    |> Enum.join("\n")
  end

  def p1(source_code) do
    %Robot{computer: Intcode.spawn(source_code)}
    |> Robot.run
    |> Map.get(:map)
    |> Enum.count
  end

  def p2(source_code) do
    %Robot{computer: Intcode.spawn(source_code), map: %{{0, 0} => :white}}
    |> Robot.run
    |> Map.get(:map)
    |> display_image
  end
end

