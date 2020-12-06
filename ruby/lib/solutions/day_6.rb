require_relative '../helpers'

input = get_input_for_day(day: 6).join("\n").split("\n\n")

def part_one(input)
  input = input.map do |i|
    i unless i.include?("\n")
  
    res = i.gsub(/\n/, '')
    res.chars.uniq
  end
  
  input.reduce(0) { |total, i| total + i.length }
end

def part_two(input)
  input = input.map do |i| 
    i = i.split("\n").map(&:chars)
    i.reduce { |res, item| res & item }
  end

  input.reduce(0) { |total, i| total + i.length } 
end

puts "Part one: #{part_one(input)}"
puts "Part two: #{part_two(input)}"