require IEx

defmodule Advent2017.Day20 do
  defmodule Particle do
    defstruct p: [x: nil, y: nil, z: nil],
              v: [x: nil, y: nil, z: nil],
              a: [x: nil, y: nil, z: nil]

    def new(string) do
      Regex.scan(~r/-*\d+/, string)
      |> List.flatten
      |> Enum.chunk_every(3)
      |> Enum.map(fn coord ->
        Enum.zip([:x, :y, :z], Enum.map(coord, &String.to_integer &1))
      end)
      |> (fn [p, v, a] -> %Particle{p: p, v: v, a: a} end).()
    end

    def fetch(map, val), do: Map.fetch(map, val)
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    file
    |> String.split("\n", trim: true)
    |> Enum.map(&Particle.new &1)
  end
end
