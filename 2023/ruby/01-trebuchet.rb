input = File.read '../input/1'

numbers = input.lines.map do |line|
  numbers = line.chars.select { |c| c.match? /\d/ }
  (numbers.first + numbers.last).to_i
end

print numbers.sum
