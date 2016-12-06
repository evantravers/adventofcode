require 'pry'

class Answer
  def initialize
    @answer = []
  end

  def alphabet
    (:a..:z).map {|a| [a, 0]}.to_h
  end

  def count_character char, index
    if @answer[index].nil?
      @answer[index] = alphabet
    end

    @answer[index][char.to_sym] += 1
  end

  def evaluate string
    string.split('').each_with_index do |char, index|
      next if char == "\n"

      self.count_character(char, index)
    end
  end

  def solve method
    return @answer.map {|char| char.send("#{method}_by") {|letter, value| value}.first}.join
  end
end

answer = Answer.new

File.foreach('input.txt') do |line|
  answer.evaluate line
end

puts "The first message is:"
puts answer.solve(:max)
puts "The last message is:"
puts answer.solve(:min)
