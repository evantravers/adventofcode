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

  def hash(number)
   @md5.hexdigest(@salt + number.to_s)
  end

  def has_confirm character, key
    possible_confirms = @confirm[character]

    return false if possible_confirms.nil?
    return true if possible_confirms.find { |c| c > key && (c - key) < 1000 }
    return false
  end

  def solve instrument=false
    number = 0

    until @pad.length > 63
      hash = hash(number)

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

      @maybe.each do |repeated_char, maybe_keys|
        maybe_keys.each do |possible_key|
          if has_confirm repeated_char, possible_key
            @pad << possible_key
            @maybe[repeated_char].delete possible_key
          end
        end
      end

      @pad.uniq!

      number += 1
    end

    @pad.sort!
    binding.pry
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
