require_relative '../helpers'

def is_tree?(char)
  char == '#'
end

def move_on_slope(position:, gradiant:, max_width:)
  {
    row: (position[:row] + gradiant[:vertical]),
    col: (position[:col] + gradiant[:horizontal]) % max_width
  }
end

def get_tree_count_for_gradiant(horizontal:, vertical:)
  input = get_input_for_day(day: 3).map(&:chars)
  max_width = input.first.length
  last_row = input.length - 1

  position = { row: 0, col: 0 }
  tree_count = 0

  while position[:row] != last_row
    position = move_on_slope(position: position, gradiant: { horizontal: horizontal, vertical: vertical }, max_width: max_width)
    tree_count += 1 if is_tree?(input[position[:row]][position[:col]])
  end

  tree_count
end

puts "Part 1:"
puts get_tree_count_for_gradiant(horizontal: 3, vertical: 1)
puts "Part 2:"

gradiants = [
  {horizontal: 1, vertical: 1},
  {horizontal: 3, vertical: 1},
  {horizontal: 5, vertical: 1},
  {horizontal: 7, vertical: 1},
  {horizontal: 1, vertical: 2}
]

puts gradiants.map { |g| get_tree_count_for_gradiant(**g) }.reduce(&:*)