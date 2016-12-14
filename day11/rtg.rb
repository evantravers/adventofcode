require 'set'
require 'pry'

ItemDescription = /a ([\w-]+ [\w-]+)/
NUMBERS         = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth']

class Item
  include Comparable

  attr_accessor :mineral, :type, :floor

  def initialize description, floor_number
    values   = description.split(/ |-compatible/)
    @mineral = values.first.to_sym
    @type    = values.last.to_sym

    @floor = floor_number
  end

  def compatible? other_item
    return @mineral == other_item.mineral
  end

  def to_s
    "#{@mineral[0].capitalize}#{@type[0].capitalize}"
  end
end

class State
  attr_accessor :elevator, :items

  def initialize
    @elevator = 0
    @items    = Set.new
  end

  def valid?
    rtgs = @items.select { |x| x.type == :generator }
    chps = @items.select { |x| x.type == :microchip }

    # if any chip is in a room with a non-matching RTG without shield, fail
    chps.each do |chip|
      if rtgs.map(&:floor).member? chip.floor &&
          rtgs.find { |rtg| rtg.compatible? chip }.floor != chip.floor
        return false
      end
    end
    return true
  end
end

problem_start = State.new

File.foreach('test.txt') do |line|
  floor_number = NUMBERS.index(line.match(/The ([\w]+) floor/).captures.first)

  descriptions = line.scan(ItemDescription).flatten
  descriptions.map do |description|
    problem_start.items << Item.new(description, floor_number)
  end
end

binding.pry
puts problem_start
