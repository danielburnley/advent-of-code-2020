require_relative '../helpers'

input = get_input_for_day(day: 1).map(&:to_i)

input.map { |i| {first: i, remainder: input - [i] } }.find do |item|
  first = item[:first]
  nums = item[:remainder]
  if nums.any? { |n| n+first == 2020 }
    puts nums.find { |n| n+first == 2020 } * first
  end
end

input.each do |i|
  remainder = input - [i]
  without_over_2020 = remainder.reject { |n| n + i >= 2020 }
  without_over_2020.each do |j|
    second_remainder = remainder - [j]
    if second_remainder.any? { |n| n+i+j == 2020}
      puts second_remainder.find { |n| n + i + j == 2020 } * i * j
    end 
  end
end
