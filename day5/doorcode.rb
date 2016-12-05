require 'digest'
require 'pry'

Md5       = Digest::MD5.new
Door_code = ARGV[0]
password  = ""

if Door_code.nil?
  puts "You forgot to enter a door ID as an argument."
  exit
end

class Decoder
  def initialize
    @count = 0
  end

  def get_next_char(string)
    hex_representation = ""
    while hex_representation[0..4] != "00000"
      hex_representation = Md5.hexdigest "#{Door_code}#{@count}"
      @count += 1
    end
    return hex_representation[5]
  end
end

decoder = Decoder.new

until password.length > 7
  password += decoder.get_next_char(Door_code)
end

puts "The answer is:"
puts password
