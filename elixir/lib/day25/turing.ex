defmodule Advent2017.Day25 do
  @moduledoc """
  Following the twisty passageways deeper and deeper into the CPU, you finally
  reach the core of the computer. Here, in the expansive central chamber, you
  find a grand apparatus that fills the entire room, suspended nanometers above
  your head.

  You had always imagined CPUs to be noisy, chaotic places, bustling with
  activity. Instead, the room is quiet, motionless, and dark.

  Suddenly, you and the CPU's garbage collector startle each other. "It's not
  often we get many visitors here!", he says. You inquire about the stopped
  machinery.

  "It stopped milliseconds ago; not sure why. I'm a garbage collector, not a
  doctor." You ask what the machine is for.

  "Programs these days, don't know their origins. That's the Turing machine!
  It's what makes the whole computer work." You try to explain that Turing
  machines are merely models of computation, but he cuts you off. "No, see,
  that's just what they want you to think. Ultimately, inside every CPU,
  there's a Turing machine driving the whole thing! Too bad this one's broken.
  We're doomed!"

  You ask how you can help. "Well, unfortunately, the only way to get the
  computer running again would be to create a whole new Turing machine from
  scratch, but there's no way you can-" He notices the look on your face, gives
  you a curious glance, shrugs, and goes back to sweeping the floor.

  You find the Turing machine blueprints (your puzzle input) on a tablet in a
  nearby pile of debris. Looking back up at the broken Turing machine above,
  you can start to identify its parts:

  A tape which contains 0 repeated infinitely to the left and right.  A cursor,
  which can move left or right along the tape and read or write values at its
  current position.  A set of states, each containing rules about what to do
  based on the current value under the cursor.  Each slot on the tape has two
  possible values: 0 (the starting value for all slots) and 1. Based on whether
  the cursor is pointing at a 0 or a 1, the current state says what value to
  write at the current position of the cursor, whether to move the cursor left
  or right one slot, and which state to use next.
  """

  def read_input_into_states(filename) do
    {:ok, file} = File.read(filename)

    file
    |> String.split("\n", trim: true)
  end
end
