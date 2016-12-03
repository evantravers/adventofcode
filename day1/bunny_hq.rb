# google advent of code solution #1

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

facing_direction = :north

instructions.each do |instruction|
  direction = instruction[0]
  distance  = instruction[1..-1].to_i

  if direction == "L"
    new_facing_direction = directions[facing_direction].first
  else
    new_facing_direction = directions[facing_direction].last
  end

  puts "#{new_facing_direction} for #{distance} blocks"
  facing_direction = new_facing_direction

  if facing_direction == :north
    current_coord[:y] += distance
  elsif facing_direction == :east
    current_coord[:x] += distance
  elsif facing_direction == :south
    current_coord[:y] -= distance
  elsif facing_direction == :west
    current_coord[:x] -= distance
  end
end

puts current_coord

puts "The solution is #{current_coord[:x] + current_coord[:y]}"
