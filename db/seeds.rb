# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
OpenWeatherMap.create(last_get: DateTime.parse('2000-01-01T00:00:00'),
           response: 'Seed record',
           criteria: 'none',
           api_key: 'none')
