class State
  attr_accessor :elevator, :items, :parent

  def initialize
    @elevator = 0
    @items    = Set.new
  end

  def valid?
    rtgs = @items.select { |x| x.type == :generator }
    chps = @items.select { |x| x.type == :microchip }

    # if any chip is in a room with an RTG
    fried_chips = chps.select { |c| rtgs.map(&:floor).include? c.floor }
    # is the chip shielded?
    fried_chips.reject! do |chip|
      compatible_rtg = rtgs.find { |r| r.compatible? chip }
      chip.floor == compatible_rtg.floor
    end
    return fried_chips.empty?
  end

  def clone
    new_copy = Marshal::load(Marshal.dump(self))
    new_copy.parent = self
    return new_copy
  end

  def display_items floor
    items = @items.select{|x| x.floor == floor}
    result = []
    items.each do |item|
      match = items.find {|m| m.compatible?(item) && m.id != item.id }
      if match
        result << :"MATCH"
        items.delete match
        items.delete item
      else
        result << item.to_s
      end
    end
    return result.sort
  end

  def inspect
    str = ""
    [3,2,1,0].each do |floor|
      if @elevator == floor
        elevator = "E"
      else
        elevator = " "
      end
      str << "F#{floor+1}:#{elevator}: #{display_items(floor)}\n"
    end
    return str
  end

  def eql?(obj)
    self.inspect == obj.inspect && self.class == obj.class
  end

  def hash
    self.inspect.hash
  end

  def possible_states(solved_states=Set.new)
    states = Set.new

    moveable_items = @items.select { |i| i.floor == @elevator }

    item_combos = moveable_items.combination(2).to_a +
                  moveable_items.combination(1).to_a

    # the move method is contructed to do nothing if impossible
    # because this is the same state, it should get filtered out in the set
    item_combos.map do |items|
      if @elevator != 3
        tmp_state = self.clone
        items.map do |item|
          tmp_state.items.find{ |x| x.id == item.id }.move_up
        end
        tmp_state.elevator += 1
        unless solved_states.include? tmp_state
          states << tmp_state if tmp_state.valid?
        end
      end

      if @elevator != 0
        tmp_state = self.clone
        items.map do |item|
          tmp_state.items.find{ |x| x.id == item.id }.move_down
        end
        tmp_state.elevator -= 1
        unless solved_states.include? tmp_state
          states << tmp_state if tmp_state.valid?
        end
      end
    end

    return states
  end

  def victory?
    @items.map { |item| item.floor == 3 }.inject(:&)
  end

  def history
    history = []
    state = self
    history << state
    while state.parent
      history << state.parent
      state = state.parent
    end
    return history
  end
end

