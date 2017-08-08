COOLDOWN_IN_MINUTES = 10
OPEN_WEATHER_MAP_URI = 'https://home.openweathermap.org/'
OPEN_WEATHER_MAP_KEY = '3fcb4e23443750cc1256f3016a160ca7'

class OpenWeatherMap < ApplicationRecord
  validates :last_get, presence: true

  def current_weather_payload
  end

  def self.latest_get
    @@latest_get = OpenWeatherMap.maximum(:last_get)
  end

  def self.safe_to_poll(check_time)
    return true if check_time > OpenWeatherMap.latest_get + COOLDOWN_IN_MINUTES.minutes
    false
  end
end
