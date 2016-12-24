require 'digest'
require 'pry'


class OneTimePad
  MAYBE_REGEX   = /(.)\1\1/
  CONFIRM_REGEX = /(.)\1\1\1\1/


  def initialize salt
    @maybe, @confirm = {}, {}

    @pad    = []
    @md5    = Digest::MD5.new
    @salt   = salt
  end

  def solve instrument=false
    number = 0

    until @pad.length > 64

      hash = @md5.hexdigest(@salt + number.to_s)

      if hash.scan(CONFIRM_REGEX).size > 0
        hash.scan(CONFIRM_REGEX).map do |char|
          char = char.first
          puts "#{number} confirm: #{hash} contains 5 #{char}" if instrument
          @confirm[char] = [] if @confirm[char].nil?
          @confirm[char] << number
        end
      end

      if hash.scan(MAYBE_REGEX).size > 0
        first_char = hash.match(MAYBE_REGEX)[1]
        unless hash.match(first_char * 4)
          puts "#{number} maybe: #{hash} contains 3 #{first_char}" if instrument
          @maybe[first_char] = [] if @maybe[first_char].nil?
          @maybe[first_char] << number
        end
      end

      @maybe.each do |maybe_key, maybe_values|
        maybe_values.each do |maybe_index|
          unless @confirm[maybe_key].nil?
            matches = @confirm[maybe_key].find do |confirm_index|
              distance = confirm_index - maybe_index
              distance <= 1000 && distance >= 1
            end
            if matches
              @pad << maybe_index
              @maybe[maybe_key].delete maybe_index
            end
          end
        end
      end

      number += 1
    end

    @pad.sort!
    binding.pry
    return @pad[63]
  end
end

puts "Test"
test = OneTimePad.new "abc"
result = test.solve
puts result
puts 22728.to_s == result

puts "Problem"
problem = OneTimePad.new "jlmsuwbz"
puts problem.solve
