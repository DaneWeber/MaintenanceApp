SATURDAY = 6
WORK_WEEK = 5
CALENDAR_WEEK = 7
WEEKEND = 2

class Chore < ApplicationRecord
  enum interval_type: { calendar_days: 0, business_days: 1 }, _suffix: true

  validates :name, presence: true
  validates :interval_days, numericality: { only_integer: true, greater_than: 0 }

  def reset_cycle_date
    self.last_done = Date.today
    self.cycle_reset = Time.now
    self.next_due = calculate_next_due()
  end

  # Functions
  def calculate_next_due
    case
    when calendar_days_interval_type?
      Date.today + self.interval_days
    when business_days_interval_type?
      self.add_business_days(start_date: Date.today, work_days: self.interval_days)
    else
      raise ArgumentError, 'calculation logic missing for this interval_type'
    end
  end

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
    # TODO kill the .to_date cleansing and instead do calendar_days.days, etc.
    start_date, work_days = date_and_natural_number(date: start_date, number: work_days)
    return add_business_days(start_date: start_date - 1, work_days: 1) if work_days == 0
    return add_business_days(start_date: start_date + 1, work_days: work_days) if start_date.wday == SATURDAY

    weeks, remainder_days = work_days.divmod(WORK_WEEK)
    calendar_days = remainder_days + (start_date.wday + remainder_days > WORK_WEEK ? WEEKEND : 0)
    delta_days = calendar_days + weeks * CALENDAR_WEEK

    start_date + delta_days
  end

  def date_and_natural_number(date:, number:)
    # TODO kill the .to_date cleansing and instead do calendar_days.days, etc.
    [(date.to_date),(number.abs.to_i)]
  end
end
