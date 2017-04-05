require 'pry'
require 'minitest/autorun'

class Blacklist
  def initialize file
    @blacklist = File.readlines(file).map { |l| l.scan(/\d+/).map(&:to_i) }

    # combine ranges
    @blacklist.sort!
    @blacklist.each_cons(2) do |items|
      # where: items.first.max >= items.last.min
      if items.first.max >= items.last.min
        items.first[1] = items.last[1]
        @blacklist.delete items.last
      end
    end
  end

  def lowest
    @blacklist.first.max + 1
  end
end

class BlacklistTest < Minitest::Test
  def test_input
    b = Blacklist.new('test.txt')
    assert_equal b.lowest, 3
  end
end

puts Blacklist.new('input.txt').lowest
