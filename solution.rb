require "http"
require "json"

pp "Where are you?"
user_location = gets.chomp

# Hidden variables
google_maps_api_key = ENV["GMAPS_KEY"]
pirate_weather_api_key = ENV["PIRATE_WEATHER_API_KEY"]

maps_url = "https://maps.googleapis.com/maps/api/geocode/json?address="+user_location+"&key="+google_maps_api_key

resp = HTTP.get(maps_url)
raw_response = resp.to_s
parsed_response = JSON.parse(raw_response)
results = parsed_response.fetch("results")
location = (results[0].fetch("geometry")).fetch("location")
lat = location.fetch("lat")
long = location.fetch("lng")

# Assemble the full URL string by adding the first part, the API token, and the last part together
pirate_weather_url = "https://api.pirateweather.net/forecast/#{pirate_weather_api_key}/#{lat},#{long}"
pp pirate_weather_url

# Place a GET request to the URL
raw_response = HTTP.get(pirate_weather_url)

require "json"

parsed_response = JSON.parse(raw_response)

currently_hash = parsed_response.fetch("currently")

current_temp = currently_hash.fetch("temperature")

puts "The current temperature is " + current_temp.to_s + "."

# Some locations around the world do not come with minutely data.
minutely_hash = parsed_response.fetch("minutely", false)

if minutely_hash
  next_hour_summary = minutely_hash.fetch("summary")

  puts "Next hour: #{next_hour_summary}"
end
