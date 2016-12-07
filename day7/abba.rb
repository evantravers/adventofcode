require 'pry'

correct_ip = 0

def is_abba(fragment)
  return false if fragment.length != 4
  return false if fragment.match(/\[|\]/)
  return false unless fragment[0] == fragment[3]
  return false unless fragment[1] == fragment[2]
  return false unless fragment[0] != fragment[1]
  return true
end

File.foreach('input.txt') do |line|
  hypernet = false
  success  = false

  line.split('').each_with_index do |char, index|
    if char == '['
      hypernet = true
      next
    end

    if char == ']'
      hypernet = false
      next
    end

    fragment = line[index..index+3]
    if is_abba(fragment)
      if hypernet == true
        success = false
        break
      else
        success = true
      end
    end
  end

  if success
    correct_ip += 1
  end
end

puts "answer:"
puts correct_ip
