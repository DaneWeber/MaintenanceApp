class CreateOpenWeatherMaps < ActiveRecord::Migration[5.1]
  def change
    create_table :open_weather_maps do |t|
      t.datetime :last_get
      t.text :response
      t.string :criteria
      t.string :api_key

      t.timestamps
    end
  end
end
