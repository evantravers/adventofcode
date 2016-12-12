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
      @multipliers.each do |mul|
        mul[:length] = mul[:length] - n
        if mul[:length] < 1
          @multipliers.delete(mul)
        end
      end
    end

    while offset < self.length
      if self.index(Command_pattern, offset) == offset
        str_length, str_times = self[offset..-1].scan(Command_pattern).first.map(&:to_i)
        pattern_length = 3 + str_length.to_s.size + str_times.to_s.size

        @multipliers << {length: str_length, times: str_times}

        # move pointer past command pattern
        decrease_multipliers pattern_length
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


input = File.read('input.txt').strip!

puts "Part 1:"
puts input.decompress.length

puts "Part 2:"
puts input.compute_size
