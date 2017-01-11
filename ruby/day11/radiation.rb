require 'set'
require 'pry'

require_relative 'item'
require_relative 'state'

ItemDescription = /a ([\w-]+ [\w-]+)/
NUMBERS         = ['first', 'second', 'third', 'fourth', 'fifth', 'sixth']

# Load in the first state of the problem
problem_start = State.new
# an array of sets!
todo          = []
solved_states = Set.new


File.foreach('input.txt') do |line|
  floor_number = NUMBERS.index(line.match(/The ([\w]+) floor/).captures.first)

  descriptions = line.scan(ItemDescription).flatten
  descriptions.map do |description|
    problem_start.items << Item.new(description, floor_number)
  end
end

todo << problem_start

until todo.empty?
  todo.each do |state|
    if state.victory?
      state.history.each do |node|
        puts node.inspect
        puts "="*60
      end

      puts "It took #{state.history.size - 1} to reach"
      exit
    end

    unless solved_states.include? state
      solved_states << state
      todo.concat(state.possible_states(solved_states).to_a)
    else
      todo.delete(state)
    end

    puts "visited states: #{solved_states.size}, todo states: #{todo.size}, depth: #{state.history.size - 1}"
  end
end
