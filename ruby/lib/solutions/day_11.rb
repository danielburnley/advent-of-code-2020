require 'pry'
require_relative '../helpers'

OPEN_CHAIR = 'L'.freeze
FULL_CHAIR = '#'.freeze
EMPTY_SPACE = '.'.freeze

input = get_input_for_day(day: 11).map(&:chars)

class SeatingArea
  attr_reader :seating

  OPEN_CHAIR = 'L'.freeze
  FULL_CHAIR = '#'.freeze
  EMPTY_SPACE = '.'.freeze

  def initialize(seating)
    @seating = seating
  end

  def simulate_movement
    surrounding_coords = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1], [0, 1],
      [1, -1], [1, 0], [1, 1]
    ]

    new_seating = []

    @seating.each_with_index do |row, row_i|
      new_row = []

      row.each_with_index do |col, col_i|
        surrounding_squares = surrounding_coords.map do |coords|
          [row_i + coords[0], col_i + coords[1]]
        end.reject do |coords|
          coords[0] < 0 || coords[1] < 0
        end.map do |coords|
          @seating.dig(coords[0], coords[1])
        end

        case col
        when OPEN_CHAIR
          occupied_seats = surrounding_squares.count(FULL_CHAIR)

          new_row << if occupied_seats > 0
                       OPEN_CHAIR
                     else
                       FULL_CHAIR
                     end
        when FULL_CHAIR
          occupied_seats = surrounding_squares.count(FULL_CHAIR)

          new_row << if occupied_seats >= 4
                       OPEN_CHAIR
                     else
                       FULL_CHAIR
                     end
        when EMPTY_SPACE
          new_row << EMPTY_SPACE
        end
      end

      new_seating << new_row
    end

    @seating = new_seating
  end

  def is_valid_position?(position)
    position[0] >= 0 && position[1] >= 0 && @seating.dig(position[0], position[1])
  end

  def chair_in_line(position, gradient)
    chairs = []
    position = [
      position[0] + gradient[0], 
      position[1] + gradient[1]
    ]

    while is_valid_position?(position)
      value_at_position = @seating[position[0]][position[1]]

      return value_at_position unless value_at_position == EMPTY_SPACE

      position = [position[0] + gradient[0], position[1] + gradient[1]]
    end

    EMPTY_SPACE
  end

  def simulate_complicated_movement
    gradients = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1], [0, 1],
      [1, -1], [1, 0], [1, 1]
    ]

    new_seating = []

    @seating.each_with_index do |row, row_i|
      new_row = []

      row.each_with_index do |col, col_i|
        seats_in_line = gradients.map { |g| chair_in_line([row_i, col_i], g) }
        full_seats_in_line = seats_in_line.count(FULL_CHAIR)

        case col
        when OPEN_CHAIR

          new_row << if full_seats_in_line > 0
                       OPEN_CHAIR
                     else
                       FULL_CHAIR
                     end
        when FULL_CHAIR
          new_row << if full_seats_in_line >= 5
                       OPEN_CHAIR
                     else
                       FULL_CHAIR
                     end
        when EMPTY_SPACE
          new_row << EMPTY_SPACE
        end
      end

      new_seating << new_row
    end

    @seating = new_seating
  end
end

# Part one
seating = SeatingArea.new(input)
previous_state = seating.seating
next_state = seating.simulate_movement

while previous_state != next_state
  previous_state = next_state
  next_state = seating.simulate_movement
end

p next_state.map { |s| s.join('') }.join('').count(FULL_CHAIR)

# Part two
seating = SeatingArea.new(input)
previous_state = seating.seating
next_state = seating.simulate_complicated_movement

while previous_state != next_state
  previous_state = next_state
  next_state = seating.simulate_complicated_movement
end

p next_state.map { |s| s.join('') }.join('').count(FULL_CHAIR)
