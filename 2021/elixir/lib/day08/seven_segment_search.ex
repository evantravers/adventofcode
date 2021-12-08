defmodule Advent2021.Day8 do
  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&read/1)
    end
  end

  def read(str) do
    [signals, output] = String.split(str, " | ", trim: true)

    %{
      signals: String.split(signals, " ", trim: true),
      output: String.split(output, " ", trim: true)
    }
  end

  def p1(input) do
    input
    |> Enum.map(fn(%{output: output}) ->
      output
      |> Enum.map(&String.length/1)
      |> Enum.count(fn
        2 -> true # 1
        4 -> true # 4
        3 -> true # 7
        7 -> true # 8
        _ -> false
      end)
    end)
    |> Enum.sum
  end

  def p2(input) do
    input
    |> Enum.map(fn(%{signals: signals, output: output}) ->
      possible = %{
        a: MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
        b: MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
        c: MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
        d: MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
        e: MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
        f: MapSet.new(["a", "b", "c", "d", "e", "f", "g"]),
        g: MapSet.new(["a", "b", "c", "d", "e", "f", "g"])
      }

      wiring =
        signals
        |> Enum.map(fn(str) ->
          str
          |> String.codepoints
          |> MapSet.new
        end)
        |> Enum.sort_by(&Enum.count/1)
        |> IO.inspect
        |> Enum.reduce(possible, fn(signal, possible) ->
          case Enum.count(signal) do
            2 -> # found 1!
              possible
              |> Map.update!(:c, &MapSet.intersection(&1, signal))
              |> Map.update!(:f, &MapSet.intersection(&1, signal))
            3 -> # found 7!
              possible
              |> Map.update!(:a, &MapSet.intersection(&1, signal))
              |> Map.update!(:c, &MapSet.intersection(&1, signal))
              |> Map.update!(:f, &MapSet.intersection(&1, signal))
            4 -> # found 4!
              possible
              |> Map.update!(:b, &MapSet.intersection(&1, signal))
              |> Map.update!(:c, &MapSet.intersection(&1, signal))
              |> Map.update!(:d, &MapSet.intersection(&1, signal))
              |> Map.update!(:f, &MapSet.intersection(&1, signal))
            7 -> # found 8!
              possible
              |> Map.update!(:a, &MapSet.intersection(&1, signal))
              |> Map.update!(:b, &MapSet.intersection(&1, signal))
              |> Map.update!(:c, &MapSet.intersection(&1, signal))
              |> Map.update!(:d, &MapSet.intersection(&1, signal))
              |> Map.update!(:e, &MapSet.intersection(&1, signal))
              |> Map.update!(:f, &MapSet.intersection(&1, signal))
              |> Map.update!(:g, &MapSet.intersection(&1, signal))
            _ -> possible
          end
        end)
        |> IO.inspect

      # Enum.map(output, &Map.get(wiring, &1))

    end)
    # |> List.flatten
    # |> Enum.sum
  end
end
