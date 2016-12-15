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

  def id
    "#{@mineral[0].capitalize}#{@type[0].capitalize}".to_sym
  end

  def move_up
    move(1)
  end

  def move_down
    move(-1)
  end

  def to_s
    return id
  end

  private

  def move n
    target_floor = @floor + n
    @floor = target_floor if (0..3).member? target_floor
  end
end

