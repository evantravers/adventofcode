# WITH MATHS!
require 'set'
require 'pry'
require 'minitest/autorun'

# Load the input to an array of arrays [distance/delay, range of scanner]
def load_input
  File
  .read("./input.txt")
  .split("\n")
    .map{|l| l.scan(/\d+/).map(&:to_i)}
end

def firewall_active?(depth, range)
  depth % ((range - 1) * 2) == 0
end

def firewall_inactive?(depth, range)
  !firewall_active?(depth, range)
end

def period(delay, range)
  ((range - 1) * 2)
end

# FIXME this is broken
# for a failure, delete all options in possible where
# (n*period_of_gate)+delay
# after writing functional code, this seems awful
def filter(possible, failure, depth_and_delay)
  (0..possible.max/2).each do |n|
    possible.delete((n * period( * failure)) + depth_and_delay)
  end
  possible
end

# returns either nil or an array of [delay, range], man this is making miss
# functional programming
def failed_the_gauntlet?(delay, gauntlet)
  gauntlet.map{|(d, r)| [d+delay, r]}
          .find{|(depth, range)| firewall_inactive?(depth, range)}
end

def find_delay(gauntlet, max=4_000_000)
  possible_delays = (2..max).to_a

  until possible_delays.empty?
    delay = possible_delays.shift

    failure = failed_the_gauntlet?(delay, gauntlet)
    unless failure
      return delay
    else
      possible_delays = filter(possible_delays, failure, delay)
    end
  end
end

def p2
  gauntlet = load_input

  find_delay(gauntlet)
end

class FirewallTest < Minitest::Test
  def test_firewall
    assert firewall_active?(0, 2)
    refute firewall_active?(1, 2)
    assert firewall_active?(2, 2)
  end
end

class GauntletTest < Minitest::Test
  def test_gauntlet
    assert !failed_the_gauntlet?(9, [[0, 3], [1, 2], [4, 4], [6, 4]]).nil?
    assert_equal nil, failed_the_gauntlet?(10, [[0, 3], [1, 2], [4, 4], [6, 4]])
  end

  def test_find_delay
    assert_equal 10, find_delay([[0, 3], [1, 2], [4, 4], [6, 4]], 15)
  end
end

# puts p2
