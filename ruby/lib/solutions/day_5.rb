require_relative '../helpers'

def find_column(pass_id)
  column_markers = pass_id[0..6]
  low = 0
  high = 127
  column_markers.each do |m|
    if m == 'F'
      high = (low + high)/2
      # puts "Low: #{low}, High: #{high}"
    elsif m == 'B'
      low = ((low + high)/2.0).ceil
      # puts "Low: #{low}, High: #{high}"
    end
  end

  throw "Column check" unless low == high
  low
end

def find_row(pass_id)
  row_markers = pass_id[6..-1]
  low = 0
  high = 7
  row_markers.each do |m|
    if m == 'L'
      high = (low + high)/2
      # puts "Low: #{low}, High: #{high}"
    elsif m == 'R'
      low = ((low + high)/2.0).ceil
      # puts "Low: #{low}, High: #{high}"
    end
  end

  throw "Row check" unless low == high
  low
end

input = get_input_for_day(day: 5)

res = input.map do |i|
  column = find_column(i.chars)
  row = find_row(i.chars)
  (column * 8) + row
end

puts "Part One: #{res.max}"

puts "Part Two: IDs missing"
p Array(0..989) - res