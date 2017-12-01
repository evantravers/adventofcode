require 'pry'
require 'minitest/autorun'

class Elf
  attr_accessor :name, :next

  def initialize name
    @name = name
  end

  def steal!
    @next = @next.next
  end
end

class Game
  attr_accessor :head, :tail

  # player 1!
  def initialize head
    @head = head
    @tail = head
  end

  def add_player elf
    @tail.next = elf
    @tail = @tail.next
    @tail.next = @head
  end

  def size
    count    = 1
    next_elf = @head.next

    while next_elf != @head
      next_elf = next_elf.next
      count += 1
    end

    count
  end
end

def solve n
  # set up the board
  game = Game.new(Elf.new(1))
  (2..n).each do |elf|
    game.add_player(Elf.new(elf))
  end

  current_player = game.head
  until current_player == current_player.next
    current_player.steal!
    current_player = current_player.next
  end

  return current_player.name
end

class ElvesTest < Minitest::Test
  def test_5_elves
    assert_equal solve(5), 3
  end
end

puts solve 3005290
