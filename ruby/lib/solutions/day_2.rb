require_relative '../helpers'

def is_valid_password?(password_amounts:, letter_required:, password:)
  letter_count = password.chars.count(letter_required)
  return letter_count >= password_amounts[0] && letter_count <= password_amounts[1]
end

def is_valid_password_two?(password_amounts:, letter_required:, password:)
  letters = password.chars
  first_char = letters[password_amounts[0] - 1]
  second_char = letters[password_amounts[1] - 1]
  return ( first_char == letter_required &&  second_char != letter_required) || (second_char == letter_required && first_char != letter_required)
end

result = get_input_for_day(day: 2).map do |line|
  split_by_spaces = line.split(' ')
  password_amounts = split_by_spaces[0].split("-").map(&:to_i)
  letter_required = split_by_spaces[1].split(":").first
  password = split_by_spaces[2]
  {
    password_amounts: password_amounts,
    letter_required: letter_required,
    password: password
  }
end.map do |check| 
  is_valid_password?(**check) 
end

puts result.count(true)

result = get_input_for_day(day: 2).map do |line|
  split_by_spaces = line.split(' ')
  password_amounts = split_by_spaces[0].split("-").map(&:to_i)
  letter_required = split_by_spaces[1].split(":").first
  password = split_by_spaces[2]
  {
    password_amounts: password_amounts,
    letter_required: letter_required,
    password: password
  }
end.map do |check| 
  is_valid_password_two?(**check) 
end

puts result.count(true)