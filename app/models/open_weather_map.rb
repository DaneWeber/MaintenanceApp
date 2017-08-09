COOLDOWN_IN_MINUTES = 10
OPEN_WEATHER_MAP_PATH = 'http://api.openweathermap.org/data/2.5/forecast/daily?'
OPEN_WEATHER_MAP_CRITERIA = 'zip=22630,us'
OPEN_WEATHER_MAP_KEY = '3fcb4e23443750cc1256f3016a160ca7'
OPEN_WEATHER_MAP_FULL_URL = OPEN_WEATHER_MAP_PATH + OPEN_WEATHER_MAP_CRITERIA + '&appid=' + OPEN_WEATHER_MAP_KEY

class OpenWeatherMap < ApplicationRecord
  validates :last_get, presence: true

  def current_weather_payload
    if OpenWeatherMap.safe_to_poll(DateTime.now)
      self.get_weather
    else
      self.retrieve_cache
    end
    self.response
  end

  def get_weather
    api_response = HTTParty.get(OPEN_WEATHER_MAP_FULL_URL)
    if api_response.success?
      self.response = api_response.body
      self.api_key = OPEN_WEATHER_MAP_KEY
      self.criteria = OPEN_WEATHER_MAP_CRITERIA
      self.last_get = DateTime.now
      self.save
    end
  end

  def retrieve_cache
    cached = OpenWeatherMap.order(:last_get).last
    self.response = cached.response
    self.api_key = cached.api_key
    self.criteria = cached.criteria
    self.last_get = cached.last_get
  end

  def self.latest_get
    @@latest_get = OpenWeatherMap.maximum(:last_get)
  end

  def self.safe_to_poll(check_time)
    return true if check_time > OpenWeatherMap.latest_get + COOLDOWN_IN_MINUTES.minutes
    false
  end
end
