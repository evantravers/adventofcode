require 'minitest/autorun'

def solve n
  elves   = (1..n).to_a
  player = 0

  until elves.size == 2
    to_be_stolen = (player + 1) % elves.size

    # stolen and banned!
    elves.delete_at(to_be_stolen)

    player += 1
  end

  return elves.first
end

class ElvesTest < Minitest::Test
  def test_5_elves
    assert_equal solve(5), 3
  end
end

puts solve 3005290
