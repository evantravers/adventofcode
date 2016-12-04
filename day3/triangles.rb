require 'pry'

possible     = 0
combinations = []

def check_sides(side1, side2, side3)
  if (side1 + side2) <= side3
    return false
  end
  if (side1 + side3) <= side2
    return false
  end
  if (side3 + side2) <= side1
    return false
  end

  true
end

File.foreach('input.txt') do |line|
  sides = line.split(' ')

  sides.map! { |num| num.to_i }

  combinations << sides
end

combinations.each do |sides|
  problem1 = sides.sort

  side_1 = problem1[0]
  side_2 = problem1[1]
  side_3 = problem1[2]

  possible += 1 if check_sides(side_1, side_2, side_3)
end

puts "Problem 1:"
puts "#{possible}\n"

possible = 0

list_of_sides = combinations.flatten

while !list_of_sides.empty?
  (0..2).each do |offset|
    side_1 = list_of_sides[0+offset]
    side_2 = list_of_sides[3+offset]
    side_3 = list_of_sides[6+offset]

    possible += 1 if check_sides(side_1, side_2, side_3)
  end
  list_of_sides = list_of_sides[9..-1]
end

puts "Problem 2:"
puts "#{possible}\n"
