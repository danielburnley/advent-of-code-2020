require 'pry'
require_relative '../helpers'

class Instruction
  attr_reader :direction, :unit

  def initialize(direction, unit)
    @direction = direction
    @unit = unit
  end

  def is_forward?
    @direction == 'F'
  end

  def is_turning?
    @direction == 'L' || @direction == 'R'
  end

  def compass?
    %w[N E S W].include?(@direction)
  end
end

class Ship
  attr_reader :position

  def initialize
    @position = [0, 0]
    @facing = 90
  end

  def execute_move(instruction)
    direction = instruction.direction

    if instruction.is_forward?
      direction = facing_to_direction
      execute_move(Instruction.new(direction, instruction.unit))
    elsif instruction.is_turning?

      case direction
      when 'L'
        @facing = (@facing - instruction.unit) % 360
      when 'R'
        @facing = (@facing + instruction.unit) % 360
      end

    else

      case direction
      when 'N'
        @position = [
          @position[0],
          @position[1] + instruction.unit
        ]
      when 'S'
        @position = [
          @position[0],
          @position[1] - instruction.unit
        ]
      when 'E'
        @position = [
          @position[0] + instruction.unit,
          @position[1]
        ]
      when 'W'
        @position = [
          @position[0] - instruction.unit,
          @position[1]
        ]
      end

    end
  end

  private

  def facing_to_direction
    case @facing
    when 0
      'N'
    when 90
      'E'
    when 180
      'S'
    when 270
      'W'
    end
  end
end

class ShipWithWaypoint
  attr_reader :position, :waypoint_position

  def initialize
    @position = [0, 0]
    @waypoint_position = [10, 1]
  end

  def execute_move(instruction)
    handle_compass_move(instruction) if instruction.compass?
    handle_turning(instruction) if instruction.is_turning?
    handle_forward_movement(instruction) if instruction.is_forward?
  end

  private

  def handle_compass_move(instruction)
    case instruction.direction
    when 'N'
      @waypoint_position[1] = @waypoint_position[1] + instruction.unit
    when 'S'
      @waypoint_position[1] = @waypoint_position[1] - instruction.unit
    when 'E'
      @waypoint_position[0] = @waypoint_position[0] + instruction.unit
    when 'W'
      @waypoint_position[0] = @waypoint_position[0] - instruction.unit
    end
  end

  def handle_turning(instruction)
    number_of_clockwork_turns = degrees_to_clockwork_turns(instruction)

    while number_of_clockwork_turns > 0
      @waypoint_position = [
        @waypoint_position[1], 
        @waypoint_position[0] * -1
      ]

      number_of_clockwork_turns -= 1
    end
  end

  def handle_forward_movement(instruction)
    number_of_moves = instruction.unit

    while number_of_moves > 0
      @position = [
        @position[0] + @waypoint_position[0],
        @position[1] + @waypoint_position[1]
      ]

      number_of_moves -= 1
    end
  end

  def degrees_to_clockwork_turns(instruction)
    unit = instruction.unit
    unit = unit * -1 if instruction.direction == "L"

    positive_degrees = ((360 + unit) % 360) / 90
  end
end

def parse_instructions(instruction)
  direction = instruction.slice!(0)

  Instruction.new(direction, instruction.to_i)
end

input = get_input_for_day(day: 12).map { |i| parse_instructions(i) }

ship = Ship.new

# input = [
#   "F10",
#   "N3",
#   "F7",
#   "R90",
#   "F11"
# ].map { |i| parse_instructions(i) }

input.each do |i|
  ship.execute_move(i)
end

p ship.position[0].abs + ship.position[1].abs

ship_b = ShipWithWaypoint.new

input.each do |i|
  ship_b.execute_move(i)
  p ship_b.position
  p ship_b.waypoint_position
end

p ship_b.position[0].abs + ship_b.position[1].abs