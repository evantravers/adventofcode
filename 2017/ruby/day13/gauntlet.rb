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

def divisor_of_known_failure?(num, failures)
  if failures.empty?
    false
  else
    failures.any?{|failure| num % failure == 0}
  end
end

def run_the_gauntlet(delay, gauntlet)
  gauntlet.map{|(d, r)| [d+delay, r]}
          .all?{|(depth, range)| firewall_inactive?(depth, range) }
end

def find_delay(gauntlet, max=4_000_000)
  failures = Set.new

  (2..max).each do |delay|
    unless divisor_of_known_failure?(delay, failures)
      case run_the_gauntlet(delay, gauntlet)
      when true
        return delay
      else
        failures << delay
      end
    end
  end
  return false
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
  def test_run_the_gauntlet
    refute run_the_gauntlet(9, [[0, 3], [1, 2], [4, 4], [6, 4]])
    assert run_the_gauntlet(10, [[0, 3], [1, 2], [4, 4], [6, 4]])
  end

  def test_find_delay
    assert_equal 10, find_delay([[0, 3], [1, 2], [4, 4], [6, 4]], 15)
  end
end

puts p2
