# google advent of code solution #1

require 'set'
require 'pry'

input = File.read "test.txt"
input = File.read "instructions.txt"

instructions = input.split ', '

# first is left, second is right
directions = {
  :north => [:west,  :east],
  :east  => [:north, :south],
  :south => [:east,  :west],
  :west  => [:south, :north],
}

current_coord = { :x => 0, :y => 0 }
@visited      = []
@answer2      = nil

facing_direction = :north

def step current_coord, direction, distance
  (1..distance.abs).each do |unit|
    if distance > 0
      current_coord[direction] += 1
    else
      current_coord[direction] -= 1
    end

    if @answer2.nil? && @visited.member?(current_coord)
      @answer2 = "Answer 2 is #{current_coord[:x] + current_coord[:y]}"
    else
      @visited << current_coord.dup
    end
  end
end

instructions.each do |instruction|
  direction = instruction[0]
  distance  = instruction[1..-1].to_i

  if direction == "L"
    new_facing_direction = directions[facing_direction].first
  else
    new_facing_direction = directions[facing_direction].last
  end

  facing_direction = new_facing_direction

  if facing_direction == :north
    step current_coord, :y, distance
  elsif facing_direction == :east
    step current_coord, :x, distance
  elsif facing_direction == :south
    step current_coord, :y, -distance
  elsif facing_direction == :west
    step current_coord, :x, -distance
  end
end

puts "The part 1 solution is #{current_coord[:x] + current_coord[:y]}"
puts @answer2
