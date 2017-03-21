require 'minitest/autorun'

class Blacklist
  def initialize file
    @blacklist = File.readlines(file).map { |l| l.scan(/\d+/).map(&:to_i) }

    # find the highest number in the ranges
    highest = @blacklist.flatten.sort.last

    # initialize an array from 0 to highest
    @list = (0..highest).to_a

    @blacklist.map do | range_values |
      @list.reject! { |i| Range.new(*range_values).include? i }
    end
  end

  def lowest
    @list.first
  end
end

class BlacklistTest < Minitest::Test
  def test_input
    b = Blacklist.new('test.txt')
    assert_equal b.lowest, 3
  end
end

puts Blacklist.new('input.txt').lowest
