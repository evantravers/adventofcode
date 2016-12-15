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

  def clone
    Marshal::load(Marshal.dump(self))
  end

  def generate_possible_states
    moveable_items = @items.find {|i| i.floor == @elevator }
    
    item_combos = moveable_items.combination(2) + moveable_items.combination(1)

  end
end

