class Chore < ApplicationRecord
  validates :name, presence: true
  validates :interval_days, numericality: { only_integer: true, greater_than: 0 }

  def due_class(due_date = next_due)
    case
    when due_date == nil
      'not-due'
    when due_date < Date.today
      'overdue'
    when due_date < Date.today + 1
      'due-today'
    when due_date < Date.today + 7
      'due-week'
    else
      'due-later'
    end
  end
end
