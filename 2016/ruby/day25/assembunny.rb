class Computer
  REGISTERS = ['a', 'b', 'c', 'd']

  attr_accessor :tape

  def initialize
    @a, @b, @c, @d = 0, 0, 0, 0
    @instruction_pointer = 0
    @instruction_set     = Array.new
    @tape                = Array.new
  end

  def set_register id, val
    instance_variable_set "@#{id}", val
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

    if is_a_register? dst
      instance_variable_set "@#{dst}", src
    end
  end

  def jnz test, offset
    test   = evaluate_argument test
    offset = evaluate_argument offset

    # this is adjusted because of the instruction pointer advance in `read`
    offset = offset.to_i - 1

    if test != 0
      @instruction_pointer += offset
    end
  end

  def tgl offset
    offset       = evaluate_argument offset
    target       = @instruction_pointer + offset
    return nil if target < 0 or target > @instruction_set.size - 1

    instruction  = @instruction_set[target]

    method, args = extract_args instruction

    if args.size == 1
      if method == "inc"
        method = "dec"
      else
        method = "inc"
      end
    elsif args.size == 2
      if method == "jnz"
        method = "cpy"
      else
        method = "jnz"
      end
    end

    new_instruction = "#{method} #{args.join ' '}"
    @instruction_set[@instruction_pointer + offset] = new_instruction
  end

  def out x
    @tape << evaluate_argument(x)
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

  def load instructions, regs: {}
    if instructions.match(/\.txt/)
      instructions = File.readlines(instructions).map(&:strip)
    else
      instructions = instructions.split(/\n/).map(&:strip).reject(&:empty?)
    end
    @instruction_set = instructions

    unless regs.empty?
      regs.each do |reg|
        set_register reg.first, reg.last
      end
    end
  end

  def execute(instrument: false)
    while @instruction_pointer < @instruction_set.length
      puts self.inspect if instrument
      read @instruction_set[@instruction_pointer]
      yield self
    end
    unless block_given?
      return @a
    end
  end

  def find_clock_speed
    speed = 0
    puts speed
    while
      initialize
      set_register 'a', speed
      while @instruction_pointer < @instruction_set.length
        read @instruction_set[@instruction_pointer]
      end
      speed += 1
    end
  end

  private

  def read line
    method, args = extract_args line
    send(method, *args)

    @instruction_pointer += 1
  end

  def extract_args(line)
    args = line.scan(/[\w\d-]+/)
    method = args.shift

    return method, args
  end

  def is_a_register? arg
    REGISTERS.include? arg
  end

  def evaluate_argument arg
    if is_a_register? arg
      instance_variable_get "@#{arg}"
    else
      arg.to_i
    end
  end
end
