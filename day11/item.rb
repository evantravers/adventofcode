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

