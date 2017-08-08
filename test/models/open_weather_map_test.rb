require 'test_helper'

class OpenWeatherMapTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # Safety First: ensure we do not call the API too frequently
  test 'API success requires date stamp' do
    test_api_call = OpenWeatherMap.new
    assert_not(test_api_call.save, 'last_get should be required')
  end

  test 'find latest successful API call' do
    older_call = OpenWeatherMap.new(last_get: DateTime.parse('2017-08-01T01:23:45'))
    assert(older_call.save, 'create an API call record with only a last_get timestamp')
    assert_equal(OpenWeatherMap.latest_get, older_call.last_get,
      'the more recent record should be the last, and later than any fixtures.')
    newer_call = OpenWeatherMap.new(last_get: DateTime.parse('2017-08-02T01:23:45'))
    assert(newer_call.save, 'create a newer API call record')
    assert_equal(OpenWeatherMap.latest_get, newer_call.last_get,
      'the more recent record should be the last, and later than any fixtures.')
    assert_not(OpenWeatherMap.safe_to_poll(DateTime.parse('2017-08-02T01:23:55')),
      'ten seconds is not enough of a cooldown')
    assert_not(OpenWeatherMap.safe_to_poll(DateTime.parse('2017-08-02T01:33:45')),
      'greater than ten minutes is the cooldown requirement')
    assert(OpenWeatherMap.safe_to_poll(DateTime.parse('2017-08-02T01:33:46')),
      'greater than ten minutes is the cooldown requirement')
  end
end
