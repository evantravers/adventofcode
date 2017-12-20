require IEx

defmodule Advent2017.Day20 do
  defmodule Particle do
    defstruct p: [x: nil, y: nil, z: nil],
              v: [x: nil, y: nil, z: nil],
              a: [x: nil, y: nil, z: nil]


    def new(string) do
      Regex.scan(~r/-*\d+/, string)
      |> List.flatten
      |> Enum.map(&String.to_integer &1)
      |> Enum.chunk_every(3)
      |> Enum.map(&Enum.zip([:x, :y, :z], &1))
      |> (fn [p, v, a] -> %Particle{p: p, v: v, a: a} end).()
    end

    def fetch(map, val), do: Map.fetch(map, val)


    @doc """
    Increase the X velocity by the X acceleration.
    Increase the Y velocity by the Y acceleration.
    Increase the Z velocity by the Z acceleration.
    Increase the X position by the X velocity.
    Increase the Y position by the Y velocity.
    Increase the Z position by the Z velocity.

        iex> Advent2017.Day20.Particle.new("p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>")
        ...> |> Advent2017.Day20.Particle.tick
        %Advent2017.Day20.Particle{a: [x: -1, y: 0, z: 0],
                                   p: [x: 4, y: 0, z: 0],
                                   v: [x: 1, y: 0, z: 0]}
    """
    def tick(p) do
      v = increment_by(p[:v], p[:a])
      %Particle{p | v: v,
                    p: increment_by(p[:p], v)}
    end
    def increment_by(list1, list2) do
        Enum.zip(list1, list2)
        |> Enum.map(fn {{key, val1,}, {_, val2}} -> {key, val1 + val2} end)
    end
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    file
    |> String.split("\n", trim: true)
    |> Enum.map(&Particle.new &1)
  end
end
