{:ok, file} = File.read("input.txt")

file = file
  |> String.split("\n", [ trim: true ] )
  |> Enum.map(
    fn (line) ->
      String.split(line, "\t")
      |> Enum.map(&(String.to_integer(&1)))
    end)

result =
  file
  |> Enum.reduce(0, fn(list, acc) ->
    diff = Enum.max(list) - Enum.min(list)
    acc + diff
  end)

IO.puts result
