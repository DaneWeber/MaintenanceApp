class RemoveApiKeyFromOpenWeatherMaps < ActiveRecord::Migration[5.1]
  def change
    remove_column :open_weather_maps, :api_key, :string
  end
end
