require 'pry'

class String
  def decompress
    command_pattern = /\((\d+)x(\d+)\)/
    offset          = 0
    string          = ""

    while offset < self.length
      if self.index(command_pattern, offset) == offset
        str_length, str_times = self[offset..-1].scan(command_pattern).first.map(&:to_i)
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
end

input = File.read('input.txt').strip!

puts input.decompress.length
