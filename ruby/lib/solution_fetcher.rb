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