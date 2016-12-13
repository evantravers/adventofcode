require 'pry'
require 'pp'

FloorDescription = /The (\w+) floor contains (?:nothing relevant|(?:a ([\w-]+ [\w-]+)(?:, | )?)+(?:and a ([\w-]+ [\w-]+))*)./
InitialFloorState = []

class Item
  include Comparable

  alias_method :eql?, :==

  attr_accessor :mineral, :type

  def initialize name
    values   = name.split(/ |-compatible/)
    @mineral = values.first.to_sym
    @type    = values.last.to_sym
  end

  def ==(other_item)
    self.class == other_item.class && @mineral == other_item.mineral
  end


  def hash
    @mineral.hash
  end

  def to_s
    "#{@mineral} #{@type}"
  end
end

class State
  attr_accessor :floors, :elevator

  def initialize(*args)
    if args.size == 1 && args.first.class == State
      old_state = args.first
      @floors, @elevator = old_state.floors, old_state.elevator
    elsif args.size == 2
      @floors   = args.first
      @elevator = args.last
    else
      puts "This either takes a state, or a Floors array and Elevator obj"
    end
  end

  def to_s
    puts @floors.reverse
  end
end

class Floor
  attr_accessor :name, :inventory

  @inventory = []
  @name      = ""

  def initialize line
    floor_values = line.match(FloorDescription).captures.compact
    @name        = floor_values.shift
    @inventory   = []

    unless floor_values.empty?
      floor_values.map { |item_name| @inventory << Item.new(item_name) }
    end
  end

  def safe? elevator=nil
    # if the elevator is docked
    current_inventory = @inventory + elevator.inventory

    # if any chip is in a room with a non-matching RTG, fail
    rtgs = current_inventory.select { |x| x.type == :generator }
    chps = current_inventory.select { |x| x.type == :microchip }

    if rtgs.size == 0 || chps.size == 0
      return true
    else
      # show which chips don't have corresponding rtgs on this floor
      # they will be fried
      return (chps - rtgs) == []
    end
  end

  def to_s
    "#{name.capitalize} Floor: #{@inventory.map(&:to_s)}"
  end
end

class Elevator < Floor
  attr_accessor :position
  def initialize
    @position  = 0
    @inventory = []
  end
end

File.foreach('test.txt') do |line|
  InitialFloorState << Floor.new(line)
end

initialstate = State.new(InitialFloorState, Elevator.new)

binding.pry

puts initialstate
