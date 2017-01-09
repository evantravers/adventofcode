require 'pry'
require 'set'

ValueDeclaration = /value (\d+) goes to bot (\d+)/
BotInstruction   = /bot (\d+) gives low to (\w+) (\d+) and high to (\w+) (\d+)/

Instructions     = File.readlines('input.txt').map{ |x| x.rstrip }

Bots   = []
Output = []

class Bot
  @chips = []
  attr_accessor :id, :high, :low, :high_id, :low_id, :chips

  def initialize(id, chip=nil)
    @id    = id
    @chips = []

    if chip
      @chips << chip
    end
  end

  def give_instructions(low, low_id, high, high_id)
    @low     = low
    @low_id  = low_id
    @high    = high
    @high_id = high_id
  end

  def execute
    low_chip = @chips.min
    if @low == :output
      Output[@low_id] = low_chip
    else
      find_bot(low_id).chips << low_chip
    end
    @chips.delete low_chip

    high_chip = @chips.max
    if @high == :output
      Output[@high_id] = high_chip
    else
      find_bot(high_id).chips << high_chip
    end
    @chips.delete high_chip

    if low_chip.number == 17 && high_chip.number == 61
      puts "I'm holding the CHIPSSS! And I'm #{@id}"
    end
  end
end

class Chip
  include Comparable
  attr_accessor :number

  def initialize num
    @number = num
  end

  def <=>(anotherchip)
    @number <=> anotherchip.number
  end
end

def find_bot(id)
  bot = Bots.find {|b| b.id == id}
  if !bot
    bot = Bot.new(id)
    Bots << bot
  end
  return bot
end

# setup the world
Instructions.each do |instruction|
  if instruction.match ValueDeclaration
    chip_num, bot_id = instruction.match(ValueDeclaration).captures.map(&:to_i)
    bot = find_bot(bot_id)
    bot.chips << Chip.new(chip_num)
  end

  if instruction.match BotInstruction
    captured_values = instruction.match(BotInstruction).captures
    bot_id          = captured_values[0].to_i
    low             = captured_values[1].to_sym
    low_id          = captured_values[2].to_i
    high            = captured_values[3].to_sym
    high_id         = captured_values[4].to_i

    bot = find_bot(bot_id)
    bot.give_instructions(low, low_id, high, high_id)
  end
end

while Bots.select {|x| x.chips.size == 2}.size > 0
  Bots.select {|x| x.chips.size == 2}.map { |x| x.execute }
end

puts "Part 2:"
puts Output[0].number * Output[1].number * Output[2].number
