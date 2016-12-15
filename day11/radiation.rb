require 'set'
require 'pry'

require_relative 'item'
require_relative 'state'

ItemDescription = /a ([\w-]+ [\w-]+)/
NUMBERS         = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth']

# Load in the first state of the problem
problem_start = State.new

File.foreach('test.txt') do |line|
  floor_number = NUMBERS.index(line.match(/The ([\w]+) floor/).captures.first)

  descriptions = line.scan(ItemDescription).flatten
  descriptions.map do |description|
    problem_start.items << Item.new(description, floor_number)
  end
end

problem_start.possible_states
