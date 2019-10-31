require 'sinatra'
require "sinatra/reloader" if development?
require 'httparty'
require 'uri'
require 'json'

LOCATIONIQ_URI = 'https://eu1.locationiq.com/v1/search.php'
ACCESS_TOKEN = '68f19731fdfc75'

set :bind, 'localhost'

get '/' do
  if params['address']
    begin
      response =
        HTTParty.get URI(
          LOCATIONIQ_URI +
          "?key=#{ACCESS_TOKEN}" +
          "&q=#{params['address']}" +
          '&format=json')

    if response.body['error']
      response.body
    else
      result = JSON.parse(response.body).first
      { lat: result['lat'], lon: result['lon'] }.to_json
    end

    rescue HTTParty::Error
      { error: "Error occurred. Try again later." }.to_json
    rescue StandardError
      { error: "Connection error. Try again later." }.to_json
    end

  else
    {
      notice: "Missing a query, example: ?address=Prague"
    }.to_json
  end
end
