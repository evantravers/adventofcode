defmodule Advent2020.Day16 do
  @moduledoc "https://adventofcode.com/2020/day/16"
  @behaviour Advent

  def setup do
    with {:ok, file} <- File.read("#{__DIR__}/input"), do: setup_string(file)
  end

  def setup_string(str) do
    [fields, your_ticket, nearby_tickets] = String.split(str, "\n\n", trim: true)

    %{fields: %{}, nearby: []}
    |> eval_fields(fields)
    |> eval_tickets(nearby_tickets)
    |> eval_tickets(your_ticket, :your_ticket)
    |> Map.update!(:your_ticket, &List.flatten/1)
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

  def valid_number?(number, %{fields: fields}) do
    rules = Map.values(fields)

    Enum.any?(rules, fn(rule) -> match_rule?(number, rule) end)
  end

  def valid_ticket?(ticket, state) do
    Enum.all?(ticket, fn(num) -> valid_number?(num, state) end)
  end

  @doc """
      iex> match_rule?(4, [1..3, 5..7])
      false
      iex> match_rule?(3, [1..3, 5..7])
      true
      iex> match_rule?(5, [1..3, 5..7])
      true
  """
  def match_rule?(num, [r1, r2]) do
    Enum.member?(r1, num) || Enum.member?(r2, num)
  end

  def p1(%{nearby: nearby} = state) do
    nearby
    |> Enum.reject(&valid_ticket?(&1, state))
    |> Enum.filter(&valid_number?(&1, state))
    |> List.flatten
    |> Enum.sum
  end

  def p2(%{nearby: nearby, fields: fields, your_ticket: ticket} = state) do
    valid =
      nearby
      |> Enum.filter(&valid_ticket?(&1, state))

    field_keys =
      Enum.reduce(fields, %{}, fn({key, rule}, locations) ->
        field_number =
          Enum.find(0..19, fn(num) ->
            valid
            |> Enum.map(&Enum.at(&1, num)) # vertical slice of numbers
            |> Enum.all?(&match_rule?(&1, rule))
          end)

        Map.put(locations, key, field_number)
      end)

    field_keys
    |> Enum.filter(fn({key, _val}) -> key =~ "departure" end)
    |> Enum.map(fn({_key, val}) -> Enum.at(ticket, val) end)
    |> Enum.product
  end
end
