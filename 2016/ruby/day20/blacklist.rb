require 'set'
require 'minitest/autorun'

class Blacklist
  def initialize file
    @blacklist = File.readlines(file).map { |l| l.scan(/\d+/).map(&:to_i) }

    @blacklist = @blacklist.sort.map { |r| Range.new(*r) }
  end

  def lowest
    # start at the max of the first range
    lowest = @blacklist.first.max + 1
    current_range = 1

    while @blacklist.find { |r| r.include? lowest }
      lowest = @blacklist[current_range].max + 1
      current_range += 1
    end

    lowest
  end

  def all
    # start at the max of the first range
    lowest       = @blacklist.first.max + 1
    possible_ips = Set.new

    (0...@blacklist.size).each do |current_range|
      if !@blacklist.find { |r| r.include? lowest }
        possible_ips << lowest
      end
      lowest = @blacklist[current_range].max + 1
    end

    possible_ips.reject{|ip| ip > 4294967295 }.size
  end
end

class BlacklistTest < Minitest::Test
  def setup
    @b = Blacklist.new('test.txt')
  end

  def test_input
    assert_equal 3, @b.lowest
  end
  def test_all
    assert_equal 2, @b.all
  end
end

problem = Blacklist.new('input.txt')
puts "Part 1:"
puts problem.lowest
puts "Part 2:"
puts problem.all

