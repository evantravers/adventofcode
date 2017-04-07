require 'minitest/autorun'
require 'set'

class Node
  NODE_DESCR = /\/dev\/grid\/node-x(?<x>\d+)-y(?<y>\d+)(?: +)(?<size>\d+)T(?: +)(?: +)(?<used>\d+)T(?: +)(?<avail>\d+)T(?: +)(?<usage>\d+)%/

  attr_accessor :x, :y, :size, :used, :avail, :usage

  def initialize string
    args = string.match(NODE_DESCR)
    args.names.each do |name|
      instance_variable_set("@#{name}", args[name].to_i)
    end
  end

  def available_space
    @size - @used
  end
end

class Grid
  attr_accessor :nodes

  def initialize file
    @nodes = []

    File.readlines(file).map do |line|
      if line.match(/\/dev\/grid\/node/)
        @nodes << Node.new(line)
      end
    end
  end

  def viable_pairs
    viable_pairs = Set.new
    nodes.permutation(2).map do |src, dst|
      next if src.used == 0
      if src.used <= dst.available_space
        viable_pairs << [src, dst]
      end
    end

    viable_pairs.size
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
    assert_equal 77, n.usage
  end
end

class TestGridSolve < Minitest::Test
  def test_input_from_site
    grid = Grid.new('test.txt')
    assert_equal 7, grid.solve
  end
end

grid = Grid.new('input.txt')
puts "Part 1:"
puts grid.viable_pairs
