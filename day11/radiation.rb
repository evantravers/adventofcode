require 'set'
require 'pry'

require_relative 'item'
require_relative 'state'

ItemDescription = /a ([\w-]+ [\w-]+)/
NUMBERS         = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth']

# Load in the first state of the problem
problem_start = State.new
# an array of sets!
stages        = [Set[problem_start]]
solved_states = Set.new


File.foreach('input.txt') do |line|
  floor_number = NUMBERS.index(line.match(/The ([\w]+) floor/).captures.first)

  descriptions = line.scan(ItemDescription).flatten
  descriptions.map do |description|
    problem_start.items << Item.new(description, floor_number)
  end
end

steps = 0

binding.pry
while true
  possible_moves = Set.new
  stages[steps].map do |state|
    # don't solve it if it's been solved
    unless solved_states.include? state
      possible_moves += state.possible_states
      solved_states << state
    end
  end

  stages[steps+1] = possible_moves

  if stages[steps+1].find {|state| state.victory? }
    puts "found it!"
    puts "It took #{steps+1} to reach"
    state = stages[steps+1].find {|st| st.victory? }
    puts state.show_history
    exit
  end

  puts "Moves: #{steps}, Searched Positions: #{solved_states.size}"
  steps += 1
end
