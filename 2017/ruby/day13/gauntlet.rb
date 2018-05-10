# WITH MATHS!
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

def p2
  gauntlet = load_input

  options = (0..5_000_000).to_a

  gauntlet.each do |(depth, range)|
    options.reject!{|delay| firewall_active?(delay+depth, range)}
  end

  options.min
end

class FirewallTest < Minitest::Test
  def test_firewall
    assert firewall_active?(0, 2)
    refute firewall_active?(1, 2)
    assert firewall_active?(2, 2)
  end
end

puts p2
