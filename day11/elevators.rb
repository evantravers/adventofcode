require 'pry'

FloorDescription = /The (\w+) floor contains (?:nothing relevant|(?:a ([\w-]+ [\w-]+)(?:,)? )+and a ([\w-]+ [\w-]+))./
Floors = []

class Item
  attr_accessor :mineral, :type

  def initialize name
    values   = name.split(/ |-compatible/)
    @mineral = values.first
    @type    = values.last
  end
end

class Floor
  attr_accessor :name, :inventory

  @inventory = []
  @name      = ""

  def initialize line
    floor_values = line.match(FloorDescription).captures
    @name        = floor_values.shift
    @inventory   = []

    unless floor_values.compact.empty?
      floor_values.map { |item_name| @inventory << Item.new(item_name) }
    end
  end
end

File.foreach('input.txt') do |line|
  Floors << Floor.new(line)
end

binding.pry

puts Floors
