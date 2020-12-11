require_relative '../helpers'

input = get_input_for_day(day: 10).map(&:to_i)
input.push(input.max + 3).prepend(0)
input.sort!

def part_one(input)
  i = 0
  ones = 0
  threes = 0
  while i < sorted.length - 1
    difference = sorted[i + 1] - sorted[i]
    ones += 1 if difference == 1
    threes += 1 if difference == 3
    i += 1
  end

  puts ones * threes
end

class NextStepCalculator
  def initialize
    @cache = {}
  end

  def valid_jump?(current, next_val)
    next_val - current <= 3
  end

  def execute(current_chain)
    count = 0
    current = current_chain.first
    return @cache[current] unless @cache[current].nil?
    return 1 if current_chain.length == 1
    return 0 unless current_chain[1..-1].any? { |n| valid_jump?(current, n) }

    Array(1..3).each do |i|
      next_val = current_chain.dig(i)
      next if next_val.nil?
      next unless valid_jump?(current, next_val)
      count += execute(current_chain[i..-1])
    end

    @cache[current] = count
    count
  end
end

def part_two(input)
  next_step_calculator = NextStepCalculator.new
  puts next_step_calculator.execute(input)
end

part_one(input)
part_two(input)