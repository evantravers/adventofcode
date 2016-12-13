require 'set'
require 'pry'

FloorDescription  = /The (\w+) floor contains (?:nothing relevant|(?:a ([\w-]+ [\w-]+)(?:, | )?)+(?:and a ([\w-]+ [\w-]+))*)./
InitialFloorState = []

class Item
  attr_accessor :mineral, :type

  def initialize name
    values   = name.split(/ |-compatible/)
    @mineral = values.first.to_sym
    @type    = values.last.to_sym
  end

  def compatible? other_item
    return @mineral == other_item.mineral
  end

  def to_s
    "#{@mineral} #{@type}"
  end
end

class State
  attr_accessor :floors, :elevator, :move_count

  def initialize(floors, elevator, move_count)
    @floors     = floors
    @elevator   = elevator
    @move_count = move_count
  end

  def to_s
    puts @floors.reverse
    puts "Elevator at position: #{@elevator}"
  end

  def valid?
    # if one invalid position, then fail
    results = @floors.map { |floor| floor.safe? }
    return results.reduce(:&)
  end

  def victory?
    # everything on the top floor, nothing below
    @floors.last.inventory.size > 0 && floors[0..-2].map { |f| f.inventory.size == 0 }
  end

  def current_floor
    @floors[@elevator]
  end

  def move_item array, direction
    array.map do |item|
      item = current_floor.inventory.delete(item)
      @floors[@elevator + direction].inventory << item
    end
  end

  def generate_moves
    if self.victory?
      puts "Found victory in #{@move_count} moves."
      exit
    end

    moves =
      current_floor.inventory.combination(1).to_set +
      current_floor.inventory.combination(2).to_set
  end

  def clone
    Marshal::load(Marshal.dump(self))
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

  def safe?
    return true if @inventory.empty?

    # if any chip is in a room with a non-matching RTG, fail
    rtgs = @inventory.compact.select { |x| x.type == :generator }
    chps = @inventory.compact.select { |x| x.type == :microchip }

    if rtgs.size == 0 || chps.size == 0
      return true
    else
      # show which chips don't have corresponding rtgs on this floor
      # they will be fried
      fried_chips =
        chps.map {|chip| rtgs.map { |generator| generator.compatible? chip } }
      return fried_chips == []
    end
  end

  def to_s
    "#{name.capitalize} Floor: #{@inventory.map(&:to_s)}"
  end
end

File.foreach('test.txt') do |line|
  InitialFloorState << Floor.new(line)
end

initialstate = State.new(InitialFloorState, 0, 0)
binding.pry

# results in new possible states
moves = initialstate.generate_moves

puts moves
