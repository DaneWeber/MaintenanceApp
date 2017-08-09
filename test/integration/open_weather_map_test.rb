OPEN_WEATHER_MAP_STUB = /api.openweathermap.org/.freeze
OPEN_WEATHER_MAP_TEST = 'http://api.openweathermap.org/.freeze'

require 'test_helper'
require 'webmock/minitest'

class OpenWeatherMapIntTest < ActionDispatch::IntegrationTest
  test "call Open Weather Map API if safe" do
    stub_body_text = "Stub created at #{DateTime.now} for #{OPEN_WEATHER_MAP_STUB} url."
    stub_request(:any, OPEN_WEATHER_MAP_STUB)
      .to_return(body: stub_body_text)
    response = HTTParty.get(OPEN_WEATHER_MAP_TEST)
    assert_equal(200, response.code, 'expect successful stub hit')
    test_api = OpenWeatherMap.new(response: 'empty')
    assert(OpenWeatherMap.safe_to_poll(DateTime.now), 'fixtures should be safely in the past')
    assert_equal(stub_body_text, test_api.current_weather_payload, 'should call the API')
    second_test_api = OpenWeatherMap.new(response: 'second')
    assert_not(OpenWeatherMap.safe_to_poll(DateTime.now), 'just made a successful call')
    assert_equal(stub_body_text, second_test_api.current_weather_payload, 'should retrieve the cache')
  end
end
