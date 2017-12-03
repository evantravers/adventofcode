defmodule Day3 do
  # first circle is 1^2
  # second circle is 3^2
  # third circle is 5^2
  # 1,3,5,7
  def find_level(target_number) do
    possible_values =
      Enum.take_every(1..9999, 2)
      |> Enum.drop_while(fn (number) -> :math.pow(number, 2) > target_number end)
    hd(possible_values)+1
  end

  # distance = steps to midpoint of circle + number of levels you are at
  def distance(num) do
    # determine the number of levels
    circle = find_level(num)
  end

  def run do
    IO.puts "ghetto tests"
    IO.puts distance(1) == 0
    IO.puts distance(12) == 3
    IO.puts distance(23) == 2
    IO.puts distance(1024) == 31

    IO.puts distance(265149)
  end
end

Day3.run
