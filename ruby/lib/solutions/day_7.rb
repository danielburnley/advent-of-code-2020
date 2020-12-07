require_relative '../helpers'

input = get_input_for_day(day: 7)

input_by_bags = input.map { |i| i.split(' bags contain ') }.map do |i|
  next [i[0], []] if i[1].include?('no other bags')

  can_contain = i[1][0..-2].split(', ').map { |bag| bag.gsub(/ bags?/, '').split(' ', 2) }
  [i[0], can_contain]
end

p input_by_bags[150]