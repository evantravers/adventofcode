require 'digest'
require 'pry'

Md5            = Digest::MD5.new
Door_code      = ARGV[0]

if Door_code.nil?
  puts "You forgot to enter a door ID as an argument."
  exit
end

class String
  def number?
    self.match(/[0-9]/)
  end
end

class Decoder
  attr_accessor :count

  def initialize
    @count = 0
  end

  def get_next_char string
    hex_representation = ""
    while hex_representation[0..4] != "00000"
      hex_representation = Md5.hexdigest "#{Door_code}#{@count}"
      @count += 1
    end

    return hex_representation[5], hex_representation[6]
  end

  def simple string
    password = ""
    until password.length > 7
      password += self.get_next_char(string).first
    end
    return password
  end

  def complex string
    password = [nil, nil, nil, nil, nil, nil, nil, nil]
    until !password.member? nil
      position, value = self.get_next_char(string)

      next unless position.number?
      position = position.to_i

      if position < 8 && password[position].nil?
        password[position] = value
      end
    end
    return password.join
  end
end


decoder = Decoder.new
decoder2 = Decoder.new

first_password  = decoder.simple(Door_code)
second_password = decoder2.complex(Door_code)

puts "The first answer is (after #{decoder.count} iterations):"
puts first_password
puts "The second answer is (after #{decoder2.count} iterations):"
puts second_password
