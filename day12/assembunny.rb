require 'pry'

class Computer
  REGISTERS = ['a', 'b', 'c', 'd']

  def initialize
    @a, @b, @c, @d = 0, 0, 0, 0
    @instruction_pointer = 0
    @instruction_set     = Array.new
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

  def jnz test, offset
    if REGISTERS.include? test
      value = instance_variable_get "@#{test}"
    else
      value = test.to_i
    end

    if value != 0
      @instruction_pointer += offset.to_i
    end
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
    @instruction_set = 
      File.readlines(instructions_file).map { |line| line.strip }
  end

  def read line
    args = line.scan(/[\w\d]+/)
    method = args.shift
    send(method, *args)

    @instruction_pointer += 1
  end

  def execute
    while @instruction_pointer < @instruction_set.length
      read @instruction_set[@instruction_pointer]
    end
  end
end

computer = Computer.new
computer.load "test.txt"
computer.execute

puts computer.inspect
