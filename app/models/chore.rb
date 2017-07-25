class Chore < ApplicationRecord
  validates :name, presence: true
  validates :interval_days, numericality: { only_integer: true, greater_than: 0 }

  def due_class
    case
    when next_due == nil
      'not-due'
    when next_due < Date.today
      'overdue'
    when next_due < Date.today + 1
      'due-today'
    when next_due < Date.today + 7
      'due-week'
    else
      'due-later'
    end
  end
end
