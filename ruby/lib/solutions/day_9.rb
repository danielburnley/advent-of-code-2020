require_relative '../helpers'

input = get_input_for_day(day: 9).map(&:to_i)

def get_sums_for_items(items)
  items.combination(2).map(&:sum)
end

def get_first_invalid_number(preamble, remaining_input)
  remaining_input.each do |i|
    return i unless get_sums_for_items(preamble).include?(i)

    preamble = preamble.append(i)[1..-1]
  end
end

def get_encryption_weakness(input, first_invalid_number)
  input.each_with_index do |_item, index|
    num_set = [input[index]]
    seeking_index = index

    while num_set.sum < first_invalid_number
      seeking_index += 1
      num_set.append(input[seeking_index])
    end

    next if num_set == [first_invalid_number]

    return num_set.min + num_set.max if num_set.sum == first_invalid_number
  end
end

preamble = input[0..24]
remaining_input = input[25..-1]
first_invalid_number = get_first_invalid_number(preamble, remaining_input)
encryption_weakness = get_encryption_weakness(input, first_invalid_number)

puts "Part one: #{first_invalid_number}"
puts "Part two: #{encryption_weakness}"
