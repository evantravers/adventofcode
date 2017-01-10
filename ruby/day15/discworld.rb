class Disk
  def initialize description
    d = description.match(/Disc #(\d+) has (\d+) positions; at time=(\d+), it is at position (\d+)./)
    @positions      = d[2].to_i
    @measured_at    = d[3].to_i
    @start_position = d[4].to_i
  end

  def open_at time
    ((@start_position + time) % @positions) == 0
  end
end

class Machine
  INFINITY = 1.0/0

  def initialize(file)
    @disks = File.readlines(file).map { |line| Disk.new(line) }
  end

  def solve
    (0..INFINITY).each do |wait_time|
      capsule_position = wait_time
      success          = true

      @disks.each do |disk|
        if success
          capsule_position += 1
          if !disk.open_at capsule_position
            success = false
          end
        end
      end

      return wait_time if success
    end
  end
end

puts "Test Case:"
test = Machine.new('test.txt')
puts "Passed" if test.solve == 5

puts "Problem 1:"
p1 = Machine.new('input.txt')
puts p1.solve
