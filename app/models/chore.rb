class Chore < ApplicationRecord
  validates :name, presence: true
  validates :interval_days, numericality: { only_integer: true, greater_than: 0 }

  def due_class
    if next_due == nil
      'not-due'
    elsif next_due < Date.today
      'overdue'
    elsif next_due < Date.today + 1
      'due-today'
    elsif next_due < Date.today + 7
      'due-week'
    else
      'due-later'
    end
  end
end
