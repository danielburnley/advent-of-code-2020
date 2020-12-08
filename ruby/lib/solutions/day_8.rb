require_relative '../helpers'

input = get_input_for_day(day: 8)

class EndOfProgram < StandardError; end

class HandheldConsole
  attr_reader :program, :counter, :acc

  def initialize(program:)
    @program = program
    @counter = 0
    @acc = 0
  end

  def execute_next_instruction
    raise EndOfProgram if @counter >= @program.length

    instruction = @program[@counter]

    case instruction
    in {op: 'acc', arg: arg}
      @acc += arg
      @counter += 1
    in {op: 'jmp', arg: arg}
      @counter += instruction[:arg]
    in {op: 'nop', arg: arg}
      @counter += 1
    end
  end
end

def run_console_until_loop(console)
  executed = []
  next_address = 0

  until executed.include?(next_address)
    executed << next_address
    console.execute_next_instruction
    next_address = console.counter
  end
end

program = input.map do |line|
  line = line.split(' ')
  {
    op: line[0],
    arg: line[1].to_i
  }
end

def part_one(program)
  console = HandheldConsole.new(program: program)
  run_console_until_loop(console)
  puts console.acc
end

part_one(program)

programs = []

program.each_with_index do |instruction, index|
  op = instruction[:op]
  next if op == 'acc'

  new_program = program.dup

  if op == 'jmp'
    new_program[index] = { op: 'nop', arg: instruction[:arg] }
  elsif op == 'nop'
    new_program[index] = { op: 'jmp', arg: instruction[:arg] }
  end

  programs << new_program
end

programs.each do |p|
  console = HandheldConsole.new(program: p)
  begin
    run_console_until_loop(console)
  rescue EndOfProgram
    puts console.acc
  end
end
