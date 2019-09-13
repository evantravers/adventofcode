defmodule Advent2018.Day4 do
  @moduledoc "https://adventofcode.com/2018/day/4"

  use Timex

  @doc """
  I'm going to store it as a %{guard_id: MapSet([<minutes they are asleep])}
  """
  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt") do
      file
      |> String.split("\n", trim: true)
      |> Enum.sort
      |> read_logs
    end
  end

  @doc """
  Timestamps are written using year-month-day hour:minute format. The guard
  falling asleep or waking up is always the one whose shift most recently
  started. Because all asleep/awake times are during the midnight hour (00:00 -
  00:59), only the minute portion (00 - 59) is relevant for those events.
  """
  def read_logs(input, guards \\ %{}, on_duty \\ nil)
  def read_logs([], guards, _), do: guards
  def read_logs([string|remaining], guards, on_duty) do
    [time_string, command] =
      ~r/\[(.*)] (.*)/
        |> Regex.scan(string)
        |> List.flatten
        |> tl

    timestamp = extract_timestamp(time_string)

    cond do
      command =~ "Guard" -> # We are switching shifts
        guard_id = extract_number(command)
        read_logs(remaining,
          Map.put_new(guards, guard_id, []),
          %{id: guard_id})
      command =~ "falls asleep" ->
        read_logs(remaining,
          guards,
          Map.put(on_duty, :nap_start, timestamp))
      command =~ "wakes up" ->
        read_logs(remaining,
          record_nap(guards, on_duty, timestamp),
          on_duty)
    end
  end

  @doc """
      iex> extract_number("this is a string with 25 numbers")
      25
  """
  def extract_number(string) do
    ~r/\d+/
      |> Regex.run(string)
      |> hd
      |> String.to_integer
  end

  def extract_timestamp(time_string) do
    Timex.parse!(time_string, "%F %R", :strftime)
  end

  def record_nap(guards, %{id: id, nap_start: start}, stop) do
    guards
    |> Map.update(id, [], fn(naps) ->
      [Interval.new(from: start, until: stop, step: [minutes: 1])|naps]
    end)
  end


  def minutes_spent_asleep({_, naps}) do
    naps
    |> Enum.map(&Enum.count/1)
    |> Enum.sum
  end

  def find_most_napped_minute(naps) do
    for interval <- naps, minute <- interval do
      NaiveDateTime.to_time(minute)
    end
    |>Enum.reduce(%{}, fn(min, count) ->
      Map.update(count, min, 1, & &1 + 1)
    end)
    |> Enum.max_by(&elem(&1, 1))
  end

  @doc """
  Given a {id, naps} tuple, returns the minute that the guard is most likely
  asleep.
  """
  def find_opportune_moment(naps) do
    naps
    |> find_most_napped_minute
    |> elem(0)
    |> Map.get(:minute)
  end

  @doc """
  Used to sort by most naps on the same minute
  """
  def most_consistent_napper({_, []}), do: 0
  def most_consistent_napper({_, naps}) do
    naps
    |> find_most_napped_minute
    |> elem(1)
  end

  def id_times_minute ({id, naps}) do
    id * find_opportune_moment(naps)
  end

  @doc """
  What is the ID of the guard you chose multiplied by the minute you chose? (In
  the above example, the answer would be 10 * 24 = 240.)
  """
  def p1 do
    load_input()
    |> Enum.max_by(&minutes_spent_asleep/1)
    |> id_times_minute
  end

  @doc """
  Strategy 2: Of all guards, which guard is most frequently asleep on the same
  minute?

  In the example above, Guard #99 spent minute 45 asleep more than any other
  guard or minute - three times in total. (In all other cases, any guard spent
  any minute asleep at most twice.)

  What is the ID of the guard you chose multiplied by the minute you chose? (In
  the above example, the answer would be 99 * 45 = 4455.)
  """
  def p2 do
    load_input()
    |> Enum.max_by(&most_consistent_napper/1)
    |> id_times_minute
  end
end
