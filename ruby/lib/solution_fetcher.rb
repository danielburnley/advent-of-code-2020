require 'dotenv/load'
require 'httparty'

def fetch_solution_for_day(day:)
  response = HTTParty.get(
    "https://adventofcode.com/2020/day/#{day}/input",
    headers: {
      Cookie: "session=#{ENV['SESSION_COOKIE']}"
    }
  )

  response.body.strip
end

day = gets.chomp

File.open("#{__dir__}/inputs/day_#{day}.txt", 'w') do |f|
  f.write(fetch_solution_for_day(day: day))
end
