captcha = fn (array_of_numbers) ->
  size = Enum.count(array_of_numbers)

  array_of_numbers
    |> Enum.with_index
    |> Enum.reduce(0, fn ({num, index}, acc) ->

      next_index = rem(index+1, size)
      next       = Enum.at(array_of_numbers, next_index)

      acc = case num == next do
        true  -> acc = acc + num
        false -> acc
      end
    end )
end

{:ok, file} = File.open "input.txt"

# it'd be much better to read in by character, but hey
numbers = IO.read(file, :all)
          |> String.trim
          |> String.split("")
          |> Enum.reject(fn(x) -> x == "" end)
          |> Enum.map(fn(x) -> String.to_integer(x) end)

IO.puts captcha.(numbers)
