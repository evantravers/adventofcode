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
    src = evaluate_argument src

    instance_variable_set "@#{dst}", src
  end

  def jnz test, offset
    test = evaluate_argument test

    # this is adjusted because of the instruction pointer advance in `read`
    offset = offset.to_i - 1

    if test != 0
      @instruction_pointer += offset
    end
  end

  def inspect
    puts "P: #{@instruction_pointer}"
    puts "I: #{@instruction_set[@instruction_pointer]}"
    puts "STATE:"
    puts "========"
    puts "A: #{@a}"
    puts "B: #{@b}"
    puts "C: #{@c}"
    puts "D: #{@d}"
    puts "========"
  end

  def load instructions_file
    @instruction_set = 
      File.readlines(instructions_file).map { |line| line.strip }
  end

  def execute
    while @instruction_pointer < @instruction_set.length
      read @instruction_set[@instruction_pointer]
    end
  end

  private

  def read line
    args = line.scan(/[\w\d-]+/)
    method = args.shift
    send(method, *args)

    @instruction_pointer += 1
  end

  def evaluate_argument arg
    if REGISTERS.include? arg
      instance_variable_get "@#{arg}"
    else
      arg.to_i
    end
  end
end

# =======================

puts "Test Data:"
computer = Computer.new
computer.load "test.txt"
computer.execute

puts computer.inspect

puts "Part 1:"
computer = Computer.new
computer.load "input.txt"
computer.execute

puts computer.inspect

puts "Part 2:"
computer = Computer.new
computer.load "input.txt"
computer.inc "c"
computer.execute

puts computer.inspect
