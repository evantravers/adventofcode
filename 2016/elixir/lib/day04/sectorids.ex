defmodule Advent2016.Day4 do
  @moduledoc """
  http://adventofcode.com/2016/day/4
  """

  @room_description ~r/(?<encrypted_name>(\w+-*)+)-(?<sector_id>\d+)\[(?<checksum>\w+)\]/
  @alphabet String.split(to_string(Enum.to_list(97..122)), "", trim: true)

  @doc """
  This function takes the encrypted name, counts the occurrences of the
  characters, sorts them first by count then by alphabetical.
  """
  def sort(name) do
    with name <- String.graphemes(name), do:
      name
      |> Enum.reject(& &1 == "-")
      |> Enum.map(fn (char) -> {Enum.count(name, & &1 == char), char} end)
      |> Enum.uniq
      |> Enum.sort(fn ({first_count, first}, {second_count, second}) ->
        if first_count == second_count do
          first < second
        else
          first_count > second_count
        end
      end)
      |> Enum.map(fn {_, char} -> char end)
      |> Enum.join
  end

  @doc ~S"""
      iex> is_room?(build_room("aaaaa-bbb-z-y-x-123[abxyz]"))
      true
      iex> is_room?(build_room("a-b-c-d-e-f-g-h-987[abcde]"))
      true
      iex> is_room?(build_room("not-a-real-room-404[oarel]"))
      true
      iex> is_room?(build_room("totally-real-room-200[decoy]"))
      false
  """
  def is_room?(room) do
    sort(room["encrypted_name"]) =~ room["checksum"]
  end

  @doc """
  Takes a string and turns it into a map modeling the aspects of the room
  description.
  """
  def build_room(str) do
    @room_description
    |> Regex.named_captures(str)
    |> Map.update!("sector_id", &String.to_integer &1)
  end

  def decode_room(r) do
    Map.put(r, "decrypted_name", rotate(r["encrypted_name"], r["sector_id"]))
  end

  @doc ~S"""
  This function takes a string and an amount, and rotates the characters
  forward on a simple cipher.

      iex> rotate("qzmt-zixmtkozy-ivhz", 343)
      "very encrypted name"
  """
  def rotate("-", _), do: " "
  def rotate(char, num) when byte_size(char) == 1 do
    Enum.at(@alphabet, rem(Enum.find_index(@alphabet, & &1 == char) + num, 26))
  end
  def rotate(string, num) do
    string
    |> String.graphemes
    |> Enum.map(& rotate(&1, num))
    |> Enum.join
  end

  def load_input do
    with {:ok, file} <- File.read("#{__DIR__}/input.txt"), do: file
    |> String.split("\n", trim: true)
    |> Enum.map(&build_room &1)
  end

  def p1 do
    load_input
    |> Enum.reduce(0, fn (room, sum_of_sector_ids) ->
      if is_room? room do
        sum_of_sector_ids + room["sector_id"]
      else
        sum_of_sector_ids
      end
    end)
  end

  def p2 do
    load_input
    |> Enum.map(&decode_room/1)
    |> Enum.find(fn(room) -> String.contains?(room["decrypted_name"], "pole") end)
    |> Map.get("sector_id")
  end
end
