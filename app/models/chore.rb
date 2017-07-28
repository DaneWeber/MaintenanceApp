class Chore < ApplicationRecord
  enum interval_type: { calendar_days: 0, business_days: 1 }

  validates :name, presence: true
  validates :interval_days, numericality: { only_integer: true, greater_than: 0 }

  def reset_cycle_date
    self.last_done = Date.today
    self.cycle_reset = Time.now
    case
    when calendar_days?
      self.next_due = Date.today + self.interval_days
    when business_days?
      self.next_due = self.add_business_days(start_date: Date.today, work_days: self.interval_days)
    else
      return false
    end
    true
  end

  # Functions
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

  def add_business_days(start_date:, work_days:)
    raise ArgumentError, 'start_date must be a Date' unless start_date.instance_of?(Date)
    raise ArgumentError, 'work_days must be a positive integer' unless work_days.is_a?(Integer) && work_days > 0
    start_date += 1 if start_date.wday == 6
    weeks, days = work_days.divmod(5)
    days += 2 if start_date.wday + days > 5
    cal_days = days + weeks * 7
    start_date + cal_days
  end
end
