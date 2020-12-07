require_relative '../helpers'

class Passport
  REQUIRED_FIELDS = %w[
    byr
    iyr
    eyr
    hgt
    hcl
    ecl
    pid
  ].freeze

  OPTIONAL_FIELDS = [
    'cid'
  ].freeze

  VALID_EYE_COLOURS = %w[
    amb
    blu
    brn
    gry
    grn
    hzl
    oth
  ].freeze

  def initialize(fields)
    @fields = fields.each_with_object({}) do |f, res|
      f = f.split(':')
      res[f[0]] = f[1]
    end
  end

  def fields_present
    @fields.keys
  end

  def is_weakly_valid_passport?
    (fields_present - OPTIONAL_FIELDS).sort == REQUIRED_FIELDS.sort
  end

  def is_strongly_valid_passport?
    return false unless is_weakly_valid_passport?

    is_valid_birth_year?(fields['byr']) &&
      is_valid_issue_year?(fields['iyr']) &&
      is_valid_expiration_year?(fields['eyr']) &&
      is_valid_height?(fields['hgt']) &&
      is_valid_hair_colour?(fields['hcl']) &&
      is_valid_eye_colour?(fields['ecl']) &&
      is_valid_passport_id?(fields['pid'])
  end

  private

  attr_reader :fields

  def is_valid_birth_year?(birth_year)
    return false unless birth_year.length == 4

    birth_year = birth_year.to_i
    birth_year.between?(1920, 2002)
  end

  def is_valid_issue_year?(issue_year)
    return false unless issue_year.length == 4

    issue_year = issue_year.to_i
    issue_year.between?(2010, 2020)
  end

  def is_valid_expiration_year?(expiration_year)
    return false unless expiration_year.length == 4

    expiration_year = expiration_year.to_i
    expiration_year.between?(2020, 2030)
  end

  def is_valid_height?(height)
    units = height[-2, 2]
    value = height[0, height.length - 2].to_i

    if units == 'cm'
      value.between?(150, 193)
    elsif units == 'in'
      value.between?(59, 76)
    else
      false
    end
  end

  def is_valid_hair_colour?(colour)
    return false unless colour.length == 7
    return false unless colour.start_with?('#')

    colour.match?('^#[a-f0-9]{6}$')
  end

  def is_valid_eye_colour?(colour)
    VALID_EYE_COLOURS.include?(colour)
  end

  def is_valid_passport_id?(passport_id)
    passport_id.match?(/^[0-9]{9}$/)
  end
end

input = get_input_for_day(day: 4).join("\n").split("\n\n")

input = input.map do |i|
  i unless i.include?("\n")

  res = i.gsub(/\n/, ' ')
end

input = input.map { |i| i.split(' ') }.map { |i| Passport.new(i) }

count = input.count(&:is_weakly_valid_passport?)

puts count

count = input.count(&:is_strongly_valid_passport?)

puts count
