require 'minitest/autorun'

class Node
  NODE_DESCR = /\/dev\/grid\/node-x(?<x>\d+)-y(?<y>\d+)(?: +)(?<size>\d+)T(?: +)(?: +)(?<used>\d+)T(?: +)(?<avail>\d+)T(?: +)(?<use>\d+)%/

  attr_accessor :x, :y, :size, :used, :avail, :use

  def initialize string
    args = string.match(NODE_DESCR)
    args.names.each do |name|
      instance_variable_set("@#{name}", args[name].to_i)
    end
  end
end

class TestNodeClass < Minitest::Test
  def test_instantiation
    n = Node.new('/dev/grid/node-x0-y0     94T   73T    21T   77%')
    assert_equal 0,  n.x
    assert_equal 0,  n.y
    assert_equal 94, n.size
    assert_equal 73, n.used
    assert_equal 21, n.avail
    assert_equal 77, n.use
  end
end

