OPEN_WEATHER_MAP_STUB = 'http://api.openweathermap.org/data/2.5/forecast/daily?appid=3fcb4e23443750cc1256f3016a160ca7&zip=22630,us'

require 'test_helper'
require 'webmock/minitest'

class OpenWeatherMapIntTest < ActionDispatch::IntegrationTest
  test "call Open Weather Map API if safe" do
    stub_body_text = "Stub created at #{DateTime.now} for #{OPEN_WEATHER_MAP_URI} url."
    stub_request(:any, OPEN_WEATHER_MAP_STUB)
      .to_return(body: stub_body_text)
    response = HTTParty.get(OPEN_WEATHER_MAP_STUB)
    assert_equal(200, response.code, 'expect successful stub hit')
    test_api = OpenWeatherMap.new(response: 'empty')
    assert(OpenWeatherMap.safe_to_poll(DateTime.now), 'fixtures should be safely in the past')
    assert_equal(stub_body_text, test_api.current_weather_payload, 'should call the API')
  end
end
