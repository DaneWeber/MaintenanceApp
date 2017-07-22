class Chore < ApplicationRecord
  validates :name, presence: true
  validates :interval_days, numericality: { only_integer: true, greater_than: 0 }
end
