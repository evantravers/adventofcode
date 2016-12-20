require 'pry'

class Computer
  REGISTERS = ['a', 'b', 'c', 'd']

  def initialize
    @a, @b, @c, @d = 0, 0, 0, 0
    @instruction_pointer = 0
    @instruction_set     = []
  end

  def inc register
    value = instance_variable_get "@#{register}"
    instance_variable_set "@#{register}", value + 1
  end

  def dec register
    value = instance_variable_get "@#{register}"
    instance_variable_set "@#{register}", value - 1
  end

  def cpy src, dst
    if REGISTERS.include? src
      # it's a register!
      value = instance_variable_get "@#{src}"
    else
      value = src.to_i
    end
    instance_variable_set "@#{dst}", value
  end

  def inspect
    puts "A: #{@a}"
    puts "B: #{@b}"
    puts "C: #{@c}"
    puts "D: #{@d}"
    puts "========"
    puts "P: #{@instruction_pointer}"
  end

  def load instructions_file
    @instruction_set = File.each_line { |line| }
  end

  def read line
    args = line.scan(/[\w\d]+/)
    method = args.shift
    self.send(method, *args)
  end

  def execute
  end
end

computer = Computer.new
computer.load "test.txt"
computer.execute

puts computer.inspect
