ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require 'webmock/minitest'

require File.expand_path '../app.rb', __FILE__

include Rack::Test::Methods

WebMock.allow_net_connect!

def app
  Sinatra::Application
end

describe 'App' do
  it 'Should return error message if external connection fails' do
    stub_request(:get,
      "https://eu1.locationiq.com/v1/search.php?format=json&key=68f19731fdfc75&q=Prague").
      with(
        headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Ruby'
        }).
      to_raise(StandardError)
    get '/?address=Prague'
    assert JSON.parse(last_response.body).member? 'error'
  end

  it 'Should return notice message if address query is missing' do
    get '/'
    assert JSON.parse(last_response.body).member? 'notice'
  end

  it 'Should return error message if address does not exist' do
    get '/?address=somewhereinthedeepspace06528'
    assert JSON.parse(last_response.body).member? 'error'
  end

  it 'Should return lat/lng if address exists' do
    get '/?address=Moscow'
    _(JSON.parse(last_response.body).keys).must_equal ['lat', 'lon']
  end
end

