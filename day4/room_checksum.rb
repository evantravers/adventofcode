require 'pry'

section_id_totals = 0
parser            = /([a-z-]+)(\d+)\[([a-z]+)\]/
answer2           = ""

class Alphabet 
  Values = ('a'..'z').to_a

  def self.get(char, shift)
    char_index = Values.index char
    return Values[(char_index+shift)%26]
  end
end

File.foreach('input.txt') do |line|
  frequency_graph = {}
  deciphered_room = ""
  parsed_line     = line.match parser

  room_code       = parsed_line[1]
  section_id      = parsed_line[2].to_i
  checksum        = parsed_line[3]

  next if checksum.length != 5

  room_code.gsub("-", "").split("").each do |char|
    if not frequency_graph[char].nil?
      frequency_graph[char] += 1
    else
      frequency_graph[char] = 1
    end
  end

  sorted_graph = frequency_graph.sort do |x,y|
    # if they are equal value go by alphabetization of character
    if x.last == y.last
      y.first <=> x.first
    # if inequal compare their values and sort least to greatest
    else
      x.last <=> y.last
    end
  end
  
  computed_checksum = sorted_graph.reverse.take(5).map {|x| x.first}.join

  if checksum == computed_checksum
    section_id_totals += section_id
  end


  room_code.gsub("-", "").split("").each do |char|
    deciphered_room += Alphabet.get(char, section_id)
  end

  if deciphered_room.match /pole/
    answer2 = "Problem part 2\n#{deciphered_room} is at section ID: #{section_id}"
  end
end

puts "Problem part 1:"
puts section_id_totals

puts answer2
