require 'pry'

possible = 0

File.foreach('input.txt') do |line|
  sides = line.split(' ')

  sides.map! { |num| num.to_i }

  sides.sort!

  side_1      = sides[0]
  side_2      = sides[1]
  side_3      = sides[2]

  if (side_1 + side_2) <= side_3
    next
  end
  if (side_1 + side_3) <= side_2
    next
  end
  if (side_3 + side_2) <= side_1
    next
  end

  possible += 1
end
puts possible
