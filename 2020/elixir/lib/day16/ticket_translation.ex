defmodule Advent2020.Day16 do
  @moduledoc "https://adventofcode.com/2020/day/16"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input") do
      [fields, your_ticket, nearby_tickets] = String.split(file, "\n\n", trim: true)

      %{fields: %{}, nearby: []}
      |> eval_fields(fields)
      |> eval_tickets(nearby_tickets)
      |> eval_tickets(your_ticket, :your_ticket)
      |> Map.update!(:your_ticket, &List.flatten/1)
    end
  end

  def eval_tickets(state, str, key \\ :nearby) do
    str
    |> String.split("\n", trim: true)
    |> tl # skip the header
    |> Enum.reduce(state, fn (string, state) ->
      ticket =
        string
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)

      Map.update(state, key, [ticket], &[ticket|&1])
    end)
  end

  def eval_fields(state, str) do
    str
    |> String.split("\n", trim: true)
    |> Enum.reduce(state, fn (string, state) ->
      values =
        ~r/(.+): (\d+)-(\d+) or (\d+)-(\d+)/
        |> Regex.run(string)
        |> tl

      field = hd(values)
      [a, b, c, d] = values |> tl |> Enum.map(&String.to_integer/1)

      state
      |> Map.update!(:fields, fn(fields) ->
        Map.put(fields, field, [a..b, c..d])
      end)
    end)
  end

  def p1(%{nearby: nearby, fields: fields}) do
    rules = Map.values(fields) |> List.flatten

    nearby
    |> List.flatten
    |> Enum.filter(fn(number) ->
      !Enum.any?(rules, fn(rule) ->
        Enum.member?(rule, number)
      end)
    end)
    |> Enum.sum
  end

  def p2(%{nearby: nearby, fields: fields, your_ticket: ticket}) do
    ticket
  end
end
