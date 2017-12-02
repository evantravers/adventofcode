captcha = fn (array_of_numbers) ->
  sum  = 0
  size = Enum.count(array_of_numbers)

  array_of_numbers
    |> Enum.with_index
    |> Enum.each( fn ({num, index}) ->

      next_index = rem(index+1, size)
      next       = Enum.at(array_of_numbers, next_index)

      if num == next do
        sum = sum + num
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
