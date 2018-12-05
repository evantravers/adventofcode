defmodule Advent2018.Day4 do
  use Timex

  @moduledoc "https://adventofcode.com/2018/day/4"

  @doc """
  I'm going to store it as a %{guard_id: MapSet([<minutes their asleep])}
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
          Map.put_new(guards, guard_id, MapSet.new),
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
    |> Map.update(id, MapSet.new(), fn(naps) ->
      MapSet.put(naps,
        Interval.new(from: start, until: stop, step: [minutes: 1]))
    end)
  end


  def minutes_spent_asleep({_, naps}) do
    naps
    |> Enum.map(&Enum.count/1)
    |> Enum.sum
  end

  @doc """
  Given a {id, naps} tuple, returns the minute that the guard is most likely
  asleep.
  """
  def find_opportune_moment(naps) do
    for interval <- Enum.to_list(naps), minute <- interval do
      NaiveDateTime.to_time(minute)
    end
    |>Enum.reduce(%{}, fn(min, count) ->
      Map.update(count, min, 1, & &1 + 1)
    end)
    |> Enum.max_by(&elem(&1, 1))
    |> elem(0)
    |> Map.get(:minute)
  end

  @doc """
  What is the ID of the guard you chose multiplied by the minute you chose? (In
  the above example, the answer would be 10 * 24 = 240.)
  """
  def p1 do
    load_input()
    |> Enum.max_by(&minutes_spent_asleep/1)
    |> (fn ({id, naps}) ->
      id * find_opportune_moment(naps)
    end).()
  end

  def p2, do: nil
end
