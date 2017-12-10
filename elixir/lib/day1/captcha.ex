defmodule Advent2017.Day1 do
  def captcha(array_of_numbers, calc_index) do
    size = Enum.count(array_of_numbers)

    array_of_numbers
    |> Enum.with_index
    |> Enum.reduce(0, fn ({num, index}, acc) ->

      next_index = calc_index.(index, size)
      next       = Enum.at(array_of_numbers, next_index)

      case num == next do
        true  -> acc + num
        false -> acc
      end
    end)
  end

  def numbers do
    {:ok, file} = File.open "./lib/day1/input.txt"

    # it'd be much better to read in by character, but hey
    IO.read(file, :all)
    |> String.trim
    |> String.split("", [trim: true ])
    |> Enum.map(fn(x) -> String.to_integer(x) end)
  end

  def p1 do
    captcha(numbers(), fn (index, size) ->
      rem(index+1, size)
    end)
  end
  def p2 do
    captcha(numbers(), fn (index, size) ->
      rem(index+(div(size,2)), size)
    end)
  end
end
