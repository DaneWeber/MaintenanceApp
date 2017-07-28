class Chore < ApplicationRecord
  enum interval_type: { calendar_days: 0, business_days: 1 }

  validates :name, presence: true
  validates :interval_days, numericality: { only_integer: true, greater_than: 0 }

  def due_class(due_date = next_due)
    raise ArgumentError, 'nil or date required' unless due_date.instance_of?(Date) || due_date.nil?

    case
    when due_date == nil
      'not-due'
    when due_date < Date.today
      'overdue'
    when due_date == Date.today
      'due-today'
    when due_date < Date.today + 7
      'due-week'
    else
      'due-later'
    end
  end

  def reset_cycle_date
    self.last_done = Date.today
    self.cycle_reset = Time.now
    case
    when calendar_days?
      self.next_due = Date.today + self.interval_days
    when business_days?
      self.next_due = Date.today + self.interval_days
    else
      return false
    end
    true
  end

end
