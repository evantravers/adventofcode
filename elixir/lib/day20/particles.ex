require IEx

defmodule Advent2017.Day20 do
  defmodule Particle do
    defstruct p: [nil, nil, nil],
              v: [nil, nil, nil],
              a: [nil, nil, nil]


    def new(string) do
      Regex.scan(~r/-*\d+/, string)
      |> List.flatten
      |> Enum.map(&String.to_integer &1)
      |> Enum.chunk_every(3)
      |> (fn [p, v, a] -> %Particle{p: p, v: v, a: a} end).()
    end

    def fetch(map, val), do: Map.fetch(map, val)


    @doc ~S"""
    Increase the X velocity by the X acceleration.
    Increase the Y velocity by the Y acceleration.
    Increase the Z velocity by the Z acceleration.
    Increase the X position by the X velocity.
    Increase the Y position by the Y velocity.
    Increase the Z position by the Z velocity.

        iex> Advent2017.Day20.Particle.new("p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>")
        ...> |> Advent2017.Day20.Particle.tick
        %Advent2017.Day20.Particle{a: [-1, 0, 0],
                                   p: [4, 0, 0],
                                   v: [1, 0, 0]}
    """
    def tick(p) do
      v = increase_by(p[:v], p[:a])
      %Particle{p | v: v,
                    p: increase_by(p[:p], v)}
    end
    def increase_by(list1, list2) do
        Enum.zip(list1, list2)
        |> Enum.map(fn {v1, v2} -> v1 + v2 end)
    end

    @doc ~S"""
        iex> Advent2017.Day20.Particle.new("p=<3,-2,1>, v=<2,0,0>, a=<-1,0,0>")
        ...> |> Advent2017.Day20.Particle.distance
        6
    """
    def distance(particle, dest \\ [0, 0, 0]) do
      Enum.zip(particle[:p], dest)
      |> Enum.map(fn {v1, v2} -> abs(v2 - v1) end)
      |> Enum.sum
    end
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    particle_field =
      file
      |> String.split("\n", trim: true)
      |> Enum.map(&Particle.new &1)

      # run the simulation until *all* particles are headed away from origin
      # closest particle is winner
  end
end
