require 'pry'
require 'minitest/autorun'

def solve n
  # set up the board
  players = []
  (1..n).each do |elf|
    players << { name: elf, victim: nil}
  end

  players.map.with_index do |elf, index|
    # choose victim
    victim = players.first[:name]
    victim = players[index+1][:name] unless players[index+1].nil?

    elf[:victim] = victim
  end

  # play
  turn = 0
  while players.size > 1
    current_player = players[turn % players.size]

    # STEALS!
    victim = players.find { |elf| elf[:name] == current_player[:victim] }

    current_player[:victim] = victim[:victim]
    players.delete victim

    turn += 1
    turn = 0 if turn > players.size
  end

  return players.last[:name]
end

class ElvesTest < Minitest::Test
  def test_5_elves
    assert_equal solve(5), 3
  end
end

puts solve 3005290
