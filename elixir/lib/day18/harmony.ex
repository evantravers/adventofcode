require IEx

defmodule Advent2017.Day18 do
  @doc ~S"""
  snd X plays a sound with a frequency equal to the value of X.

      iex> Advent2017.Day18.snd(%{pointer: 0}, "12")
      %{snd: 12, pointer: 1}
  """
  def snd(state, x) do
    Map.put(state, :snd, e(state, x))
    |> next
  end

  @doc ~S"""
  set X Y sets register X to the value of Y.

      iex> Advent2017.Day18.set(%{pointer: 0, f: 0}, "f", "3")
      %{f: 3, pointer: 1}

      iex> Advent2017.Day18.set(%{pointer: 0, f: 3}, "x", "f")
      %{f: 3, x: 3, pointer: 1}
  """
  def set(state, x, y) do
    Map.put(state, a(x), e(state, y))
    |> next
  end

  @doc ~S"""
  add X Y increases register X by the value of Y.

      iex> Advent2017.Day18.add(%{pointer: 0, f: 3}, "f", "f")
      %{f: 6, pointer: 1}
  """
  def add(state, x, y) do
    Map.put(state, a(x), e(state, x) + e(state, y))
    |> next
  end

  @doc ~S"""
  mul X Y sets register X to the result of multiplying the value contained in
  register X by the value of Y.

      iex> Advent2017.Day18.mul(%{pointer: 0, f: 3}, "f", "f")
      %{f: 9, pointer: 1}
  """
  def mul(state, x, y) do
    Map.put(state, a(x), e(state, x) * e(state, y))
    |> next
  end

  @doc ~S"""
  mod X Y sets register X to the remainder of dividing the value contained in
  register X by the value of Y (that is, it sets X to the result of X modulo
  Y).

      iex> Advent2017.Day18.mod(%{pointer: 0, f: 3}, "f", "2")
      %{f: 1, pointer: 1}
  """
  def mod(state, x, y) do
    Map.put(state, a(x), rem(e(state, x), e(state,y)))
    |> next
  end

  @doc ~S"""
  rcv X recovers the frequency of the last sound played, but only when the
  value of X is not zero. (If it is zero, the command does nothing.)

      iex> Advent2017.Day18.rcv(%{pointer: 0, f: 3, snd: 12}, "f")
      12
  """
  def rcv(state, x) do
    if e(state, x) != 0 do
      Map.put(state, :halt, true)
    end
  end

  @doc ~S"""
  jgz X Y jumps with an offset of the value of Y, but only if the value of X
  is greater than zero. (An offset of 2 skips the next instruction, an offset
  of -1 jumps to the previous instruction, and so on.)

      iex> Advent2017.Day18.jgz(%{pointer: 0, f: 3}, "3", "2")
      %{pointer: 2, f: 3}
      iex> Advent2017.Day18.jgz(%{pointer: 0, f: 3}, "-3", "2")
      %{pointer: 1, f: 3}
  """
  def jgz(state, x, y) do
    case e(state, x) > 0 do
      true  -> Map.update!(state, :pointer, &(&1 + e(state, y)))
      false -> next(state)
    end
  end

  def a(str), do: String.to_atom(str)
  def next(state), do: Map.update!(state, :pointer, &(&1+1))

  @doc ~S"""
  e evaluates a variable by the stack. If there's a register, it returns that.
  """
  def e(state, var) do
    cond do
      Enum.member?(Map.keys(state), a(var)) ->
        state[a(var)]
      Regex.match?(~r/[a-z]/, var) ->
        0
      true ->
        String.to_integer(var)
    end
  end

  def run(instructions, state, opts \\ [])
  def run(instructions, state, opts) do
    case state[:halt] do
      true -> state
      _ ->
        instruction   = Enum.at(instructions, state[:pointer])
        [method|args] = String.split(instruction, " ", [trim: true])

        if opts[:debug] do
          IO.inspect state
          IO.puts "------"
          IO.puts instruction
        end

        run(instructions, apply(Advent2017.Day18, a(method), [state | args]))
    end
  end

  def p1 do
    {:ok, file} = File.read(__DIR__ <> "/input.txt")

    file
    |> String.split("\n")
    |> run(%{pointer: 0})
    |> Map.fetch!(:snd)
  end
end
