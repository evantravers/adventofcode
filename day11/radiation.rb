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


File.foreach('input.txt') do |line|
  floor_number = NUMBERS.index(line.match(/The ([\w]+) floor/).captures.first)

  descriptions = line.scan(ItemDescription).flatten
  descriptions.map do |description|
    problem_start.items << Item.new(description, floor_number)
  end
end

number_of_moves = 0

while true
  possible_moves = stages[number_of_moves].map(&:possible_states).inject(&:+)

  if possible_moves.find {|state| state.victory? }
    puts "found it!"
    puts "It took #{number_of_moves} to reach"
    puts possible_moves.find { |state| state.victory? }.inspect
    exit
  end

  stages[number_of_moves+1] = possible_moves
  puts "Moves: #{number_of_moves}"
  number_of_moves += 1
end
binding.pry

puts "yay"
