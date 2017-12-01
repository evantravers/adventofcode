require 'pry'

class String
  Command_pattern = /\((\d+)x(\d+)\)/

  def decompress
    offset          = 0
    string          = ""

    while offset < self.length
      if self.index(Command_pattern, offset) == offset
        str_length, str_times = self[offset..-1].scan(Command_pattern).first.map(&:to_i)
        pattern_length = 3 + str_length.to_s.size + str_times.to_s.size

        # move the pointer past the command pattern
        offset += pattern_length

        # multiply the string by number of times
        string += (self[offset, str_length] * str_times)

        # move the pointer past the compressed data
        offset += str_length
      else
        string += self[offset]
        offset += 1
      end
    end

    return string
  end

  def compute_size
    offset = 0
    total  = 0

    @multipliers = []

    def decrease_multipliers n
      @multipliers.map { |mul| mul[:length] = mul[:length] - n }
      @multipliers.select! { |mul| mul[:length] > 0 }
    end

    while offset < self.length
      if self.index(Command_pattern, offset) == offset
        str_length, str_times = self[offset..-1].scan(Command_pattern).first.map(&:to_i)
        pattern_length = 3 + str_length.to_s.size + str_times.to_s.size

        decrease_multipliers(pattern_length)

        @multipliers << {length: str_length, times: str_times}

        # move pointer past command pattern
        offset += pattern_length
      else
        total_multiplier = @multipliers.inject(1) { |memo, m| memo * m[:times] }
        decrease_multipliers 1

        total  += total_multiplier
        offset += 1
      end
    end

    return total
  end
end

puts "(3x3)XYZ".compute_size == "XYZXYZXYZ".size
puts "X(8x2)(3x3)ABCY".compute_size == "XABCABCABCABCABCABCY".size
puts "(27x12)(20x12)(13x14)(7x10)(1x12)A".compute_size == 241920
puts "(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN".compute_size == 445

input = File.read('input.txt').strip!

puts "Part 1:"
puts input.decompress.length

puts "Part 2:"
puts input.compute_size
