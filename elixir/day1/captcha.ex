captcha = fn (array_of_numbers) ->
  size = Enum.count(array_of_numbers)

  array_of_numbers
  |> Enum.with_index
  |> Enum.reduce(0, fn ({num, index}, acc) ->

    next_index = rem(index+1, size)
    next       = Enum.at(array_of_numbers, next_index)

    case num == next do
      true  -> acc + num
      false -> acc
    end
  end)
end

captcha2 = fn (array_of_numbers) ->
  size = Enum.count(array_of_numbers)

  array_of_numbers
  |> Enum.with_index
  |> Enum.reduce(0, fn ({num, index}, acc) ->

    next_index = rem(index+(div(size,2)), size)
    next       = Enum.at(array_of_numbers, next_index)

    case num == next do
      true  -> acc + num
      false -> acc
    end
  end)
end

{:ok, file} = File.open "input.txt"

# it'd be much better to read in by character, but hey
numbers =
  IO.read(file, :all)
  |> String.trim
  |> String.split("", [trim: true ])
  |> Enum.map(fn(x) -> String.to_integer(x) end)

IO.puts captcha.(numbers)
IO.puts captcha2.(numbers)
