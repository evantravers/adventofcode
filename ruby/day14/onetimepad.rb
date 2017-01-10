require 'digest'
require 'set'
require 'pry'

class String
  def groups_of number
    self.split('').chunk_while{ |a, b| a == b }.select{ |g| g.size >= number }
  end
end

class OneTimePad
  def initialize salt
    @maybe, @confirm = {}, {}

    @pad  = Set.new
    @md5  = Digest::MD5.new
    @salt = salt
  end

  def hash(number)
   @md5.hexdigest(@salt + number.to_s)
  end

  def has_confirm character, key
    possible_confirms = @confirm[character]

    return false if possible_confirms.nil?
    return true  if possible_confirms.find { |c| c > key && (c - key) <= 1000 }
    return false
  end

  def solve(instrument=false)
    number = 0

    until @pad.length > 70
      hash = hash(number)

      # memoize confirm hashes
      hash.groups_of(5).each do |char|
        char = char.first
        puts "#{number} confirm: #{hash} contains 5 #{char}" if instrument
        @confirm[char] = [] if @confirm[char].nil?
        @confirm[char] << number
      end

      # memoize the maybe hashes
      if !hash.groups_of(3).empty?
        first_char = hash.groups_of(3).first[0]
        @maybe[first_char] = [] if @maybe[first_char].nil?
        @maybe[first_char] << number
      end

      # evaluate the memoized options
      @maybe.each do |repeated_char, maybe_keys|
        maybe_keys.each do |possible_key|
          if has_confirm repeated_char, possible_key
            @pad << possible_key
          end
        end
      end

      number += 1
    end

    return @pad.to_a.sort[63]
  end
end

puts "Test"
test = OneTimePad.new "abc"
result = test.solve
puts result
puts 22728 == result

puts "Problem"
problem = OneTimePad.new "jlmsuwbz"
puts problem.solve
