COOLDOWN_IN_MINUTES = 10

class OpenWeatherMap < ApplicationRecord
  validates :last_get, presence: true

  def safe_to_poll(check_time)
    return true  if check_time > OpenWeatherMap.maximum(:last_get) + COOLDOWN_IN_MINUTES.minutes
    false
  end
end
