require IEx

defmodule Advent2017.Day20 do
  @moduledoc """
  New plan, "borrowed" from clever redditor: Run the sim. If the farthest
  particle has the highest acceleration and velocity, remove it, it has
  "escaped" it has "escaped". If collision, remove from set. When you have one
  left, that's the closest to origin.
  """

  defmodule Particle do
    @moduledoc """
    Representing a single particle, with functions to manipulate its state.
    """

    defstruct pos: [nil, nil, nil],
              vel: [nil, nil, nil],
              acc: [nil, nil, nil],
              id: nil


    def new({string, id}) do
      ~r/-*\d+/
      |> Regex.scan(string)
      |> List.flatten
      |> Enum.map(&String.to_integer &1)
      |> Enum.chunk_every(3)
      |> (fn [p, v, a] -> %Particle{id: id, pos: p, vel: v, acc: a} end).()
    end

    def fetch(map, val), do: Map.fetch(map, val)


    @doc ~S"""
    Increase the X velocity by the X acceleration.
    Increase the Y velocity by the Y acceleration.
    Increase the Z velocity by the Z acceleration.
    Increase the X position by the X velocity.
    Increase the Y position by the Y velocity.
    Increase the Z position by the Z velocity.

        iex> Advent2017.Day20.Particle.new({"p=<3,0,0>, v=<2,0,0>, a=<-1,0,0>", 2})
        ...> |> Advent2017.Day20.Particle.tick
        %Advent2017.Day20.Particle{acc: [-1, 0, 0],
                                   pos: [4, 0, 0],
                                   vel: [1, 0, 0],
                                   id: 2}
    """
    @spec tick(Particle) :: Particle
    def tick(p) do
      new_velocity = increase_by(p[:vel], p[:acc])
      new_position = increase_by(p[:pos], new_velocity)
      %Particle{p | vel: new_velocity,
                    pos: new_position,
      }
    end
    def increase_by(list1, list2) do
      list1
      |> Enum.zip(list2)
      |> Enum.map(fn {v1, v2} -> v1 + v2 end)
    end

    @doc ~S"""
        iex> Advent2017.Day20.Particle.new({"p=<3,-2,1>, v=<2,0,0>, a=<-1,0,0>", 0})[:pos]
        ...> |> Advent2017.Day20.Particle.distance
        6
    """
    def distance(particle, dest \\ [0, 0, 0])
    def distance(coords, dest) when is_list(coords) do
      coords
      |> Enum.zip(dest)
      |> Enum.map(fn {v1, v2} -> abs(v2 - v1) end)
      |> Enum.sum
    end
  end


  def simulate(particles) when length(particles) == 1, do: particles
  def simulate(particles) do
    particles
    |> Enum.map(&Particle.tick &1)
    |> collision_detection
    |> filter_escapees
    |> simulate
  end

  def greatest(particles, attr) do
    particles
    |> Enum.sort(fn p1, p2 ->
      Particle.distance(p1[attr]) < Particle.distance(p2[attr])
    end)
    |> Enum.reverse
  end

  def filter_escapees(particles) do
    cond do
      hd(greatest(particles, :pos)) == hd(greatest(particles, :acc)) ->
        filter_escapees(List.delete(particles, hd(greatest(particles, :pos))))
      hd(greatest(particles, :pos)) == hd(greatest(particles, :vel)) ->
        filter_escapees(List.delete(particles, hd(greatest(particles, :pos))))
      true -> particles
    end
  end

  @doc ~S"""
  Remove particles who are occuping the same [x, y, z]

      iex> [%Advent2017.Day20.Particle{pos: [1, 2, 4], vel: [2, 2, 0]}, %Advent2017.Day20.Particle{pos: [1, 2, 4], vel: [2, 0, 0]}]
      ...> |> Advent2017.Day20.collision_detection
      ...> |> Enum.count
      0
  """
  def collision_detection(particles) do
    particles
    |> Enum.reduce([], fn particle, list ->
      if Enum.find(Enum.map(list, & &1[:pos]), fn match -> match[:pos] == particle[:pos] end) do
        list
      else
        [particle|list]
      end
    end)
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    file
    |> String.split("\n", trim: true)
    |> Enum.with_index
    |> Enum.map(&Particle.new &1)
    |> simulate
  end

  def p2 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    {_, escapees} =
      file
      |> String.split("\n", trim: true)
      |> Enum.with_index
      |> Enum.map(&Particle.new &1)
      |> simulate

    escapees
  end
end
