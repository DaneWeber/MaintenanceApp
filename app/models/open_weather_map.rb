COOLDOWN_IN_MINUTES = 10.freeze
OPEN_WEATHER_MAP_PATH = 'http://api.openweathermap.org/data/2.5/forecast/daily?'.freeze
OPEN_WEATHER_MAP_CRITERIA = 'zip=22630,us&cnt=16'.freeze
OPEN_WEATHER_MAP_KEY = Rails.application.secrets.open_weather_map_key.freeze
OPEN_WEATHER_MAP_FULL_URL = OPEN_WEATHER_MAP_PATH + OPEN_WEATHER_MAP_CRITERIA + '&appid=' + OPEN_WEATHER_MAP_KEY
OPEN_WEATHER_MAP_FULL_URL.freeze

class OpenWeatherMap < ApplicationRecord
  validates :last_get, presence: true

  def refresh
    OpenWeatherMap.safe_to_poll(DateTime.now) ? self.get_weather : self.retrieve_cache
  end

  def current_weather_payload
    self.refresh
    response
  end

  def get_weather
    api_response = HTTParty.get(OPEN_WEATHER_MAP_FULL_URL)
    if api_response.success?
      self.response = api_response.body
      self.criteria = OPEN_WEATHER_MAP_CRITERIA
      self.last_get = DateTime.now
      self.save
    end
  end

  def retrieve_cache
    cached = OpenWeatherMap.order(:last_get).last
    self.response = cached.response
    self.criteria = cached.criteria
    self.last_get = cached.last_get
  end

  def self.latest_get
    OpenWeatherMap.maximum(:last_get)
  end

  def self.safe_to_poll(check_time)
    check_time > OpenWeatherMap.latest_get + COOLDOWN_IN_MINUTES.minutes ? true : false
  end

  # Utility
  def self.fahrenheit_from_kelvin(kelvin)
    kelvin * 9 / 5 - 459.67
  end
end
