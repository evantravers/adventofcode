require 'pry'
require 'set'

ValueDeclaration = /value (\d+) goes to bot (\d+)/
BotInstruction   = /bot (\d+) gives low to (\w+) (\d+) and high to (\w+) (\d+)/

Instructions     = File.readlines('input.txt').map{ |x| x.rstrip }

@bots = []
@bins = []

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
end

class Chip
  attr_accessor :number

  def initialize num
    @number = num
  end
end

def find_bot id
  bot = @bots.find {|b| b.id == id}
  if !bot
    bot = Bot.new(id)
    @bots << bot
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
    low             = captured_values[1]
    low_id          = captured_values[2].to_i
    high            = captured_values[3]
    high_id         = captured_values[4].to_i

    bot = find_bot bot_id
    bot.give_instructions(low, low_id, high, high_id)
  end
end

binding.pry
puts @bots
