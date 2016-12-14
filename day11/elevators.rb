require 'set'
require 'pry'

FloorDescription  = /The (\w+) floor contains (?:nothing relevant|(?:a ([\w-]+ [\w-]+)(?:, | )?)+(?:and a ([\w-]+ [\w-]+))*)./
InitialFloorState = []
ReachableStates   = Set.new

class Item
  include Comparable

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

  def == obj
    self.to_s == obj.to_s
  end

  def hash
    self.to_s.hash
  end
end

class State
  attr_accessor :floors, :elevator, :move_count

  alias_method :eql?, :==

  def initialize(floors, elevator, move_count)
    @floors     = floors
    @elevator   = elevator
    @move_count = move_count
  end

  def to_s
    "#{@floors.reverse.map{|f| f.to_s }.join("\n")}" +
    "Elevator at position: #{@elevator}\n" +
    "Number of moves: #{@move_count}"
  end

  def valid?
    results = @floors.map { |floor| floor.safe? }
    return results.reduce(:&)
  end

  def victory?
    # everything on the top floor, nothing below
    return @floors.last.inventory.size > 0 && floors[0..-2].map { |f| f.inventory.size == 0 }.inject(&:&)
  end

  def current_floor
    @floors[@elevator]
  end

  def move_item array, direction
    array.map do |item|
      moving_item = current_floor.inventory.delete(item)
      @floors[@elevator + direction].inventory << moving_item
    end

    @move_count += 1
    @elevator = @elevator + direction
  end

  def generate_moves
    possible_moves = Set.new

    moves =
      current_floor.inventory.combination(1).to_set +
      current_floor.inventory.combination(2).to_set

    if @elevator == 0
      moves.map do |items|
        new_state = self.clone
        new_state.move_item(items, 1)
        possible_moves << new_state if new_state.valid?   
      end
    elsif @elevator == @floors.size
      moves.map do |items|
        new_state = self.clone
        new_state.move_item(items, -1)
        possible_moves << new_state if new_state.valid?   
      end
    else
      moves.map do |items|
        new_state = self.clone
        new_state.move_item(items, 1)
        possible_moves << new_state if new_state.valid?   

        new_state = self.clone
        new_state.move_item(items, -1)
        possible_moves << new_state if new_state.valid?   
      end
    end

    return possible_moves
  end

  def == obj
    return self.to_s == obj.to_s
  end

  def clone
    this = Marshal::load(Marshal.dump(self))
    this.move_count += 1
    return this
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
    rtgs = @inventory.select { |x| x.type == :generator }
    chps = @inventory.select { |x| x.type == :microchip }

    if rtgs.size == 0 || chps.size == 0
      return true
    else
      # show which chips don't have corresponding rtgs on this floor
      # they will be fried
      fried_chips =
        chps.map {|chip| rtgs.find {|rtg| rtg.mineral != chip.mineral }}
      return fried_chips.compact.empty?
    end
  end

  def to_s
    "#{name.capitalize} Floor: #{@inventory.map(&:to_s).join(", ")}"
  end
end

File.foreach('test.txt') do |line|
  InitialFloorState << Floor.new(line)
end

initialstate = State.new(InitialFloorState, 0, 0)

# results in new possible states
moves = initialstate.generate_moves

binding.pry

puts moves
