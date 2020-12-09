require_relative '../helpers'

input = get_input_for_day(day: 7)

class Bag
  attr_reader :colour

  def initialize(colour:, can_contain:)
    @colour = colour
    @can_contain = can_contain
  end

  def bags_can_contain
    @can_contain.map { |b| b[1] }
  end

  def can_contain
    @can_contain.reduce({}) do |res, b| 
      res[b[1]] = b[0].to_i 
      res
    end
  end
end

input_by_bags = input.map { |i| i.split(' bags contain ') }.map do |i|
  next Bag.new(colour: i[0], can_contain: []) if i[1].include?('no other bags')

  can_contain = i[1][0..-2].split(', ').map { |bag| bag.gsub(/ bags?/, '').split(' ', 2) }

  Bag.new(
    colour: i[0],
    can_contain: can_contain
  )
end

bag_map = input_by_bags.reduce({}) do |res, bag| 
  res[bag.colour] = bag 
  res
end

def part_one(bag_map)
  result = bag_map.keys.reduce(0) do |total, bag|
    can_contain_gold = false
    contains = bag_map[bag].bags_can_contain.dup
    matched = []
  
    while !contains.empty?
      next_bag_colour = contains.pop
      matched.push(next_bag_colour)
  
      next_bag = bag_map[next_bag_colour]
  
      if next_bag.colour == "shiny gold"
        can_contain_gold = true
        break
      end
  
      contains += next_bag.bags_can_contain - matched
    end
  
    total += 1 if can_contain_gold
    total
  end
  
  puts result
end

def get_total_bags_for(bag_map, colour)
  bag = bag_map[colour]
  return 0 if bag.can_contain.empty?

  total = 0
  bag.can_contain.each do |bag_colour,number_to_hold|
    total += number_to_hold + (number_to_hold * get_total_bags_for(bag_map, bag_colour))
  end

  total
end


def part_two(bag_map)
  start = bag_map["shiny gold"]
  total = 0
  bags_to_count = start.can_contain.keys
  puts get_total_bags_for(bag_map, "shiny gold")
end

# part_one(bag_map)
part_two(bag_map)
