class Chore < ApplicationRecord
  validates :name, presence: true
  validates :interval_days, numericality: { only_integer: true, greater_than: 0 }

  def due
    # 'due-today'
    # next_due
    if next_due == nil
      'nil'
    elsif next_due == Date.today
      'due-today'
    elsif next_due < Date.today
      'overdue'
    elsif next_due > Date.today - 7
      'due-week'
    else
      'not-due'
    end
  end
end
