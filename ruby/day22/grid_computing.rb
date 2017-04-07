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

  def pretty_print
    ratio = @used.to_f/@size.to_f
    case
    when ratio >= 0.9
      return "#"
    when ratio >= 0.4
      return "."
    when ratio == 0
      return "_"
    end
  end
end

class Grid
  attr_accessor :nodes, :goal

  def initialize file
    @nodes = [[]]

    File.readlines(file).map do |line|
      if line.match(/\/dev\/grid\/node/)
        n = Node.new(line)
        @nodes[n.x] = [] if @nodes[n.x].nil?
        @nodes[n.x][n.y] = n
      end
    end

    # The goal is at x: max, y: 0
    @goal = {x: @nodes[0].size-1, y: 0}
  end

  def viable_pairs
    viable_pairs = Set.new
    @nodes.flatten.permutation(2).map do |src, dst|
      next if src.used == 0
      if src.used <= dst.available_space
        viable_pairs << [src, dst]
      end
    end

    viable_pairs.size
  end

  def solve
    self.inspect
    return 0
  end

  def inspect
    @nodes.transpose.each do |row|
      row.each do |node|
        if [node.x, node.y] == goal.values
          print "G"
        else
          print node.pretty_print
        end
      end
      puts
    end
    puts
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
