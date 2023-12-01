input = File.read '../input/1'

p1 =
  input.lines.map do |line|
    numbers = line.chars.select { |c| c.match? /\d/ }
    (numbers.first + numbers.last).to_i
  end.sum

def process(num)
  case num
  when /one/
    1
  when /two/
    2
  when /three/
    3
  when /four/
    4
  when /five/
    5
  when /six/
    6
  when /seven/
    7
  when /eight/
    8
  when /nine/
    9
  else
    num.to_i
  end
end

p2 =
  input.lines.map do |line|
    numbers = line.scan /\d|one|two|three|four|five|six|seven|eight|nine/
    (process(numbers.first)*10 + process(numbers.last))
  end.sum

print "#{p1}\n"
print p2
