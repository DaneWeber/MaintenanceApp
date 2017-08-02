require 'test_helper'

class ChoreTest < ActiveSupport::TestCase
  # Arrange
  test_chore = Chore.new
  monday_2017_06_12 = Date.parse('2017-06-12')

  # Act

  # Assert
  test 'add_business_days' do
    assert_equal(monday_2017_06_12 + 1, test_chore.add_business_days(start_date: monday_2017_06_12, work_days: 1), 'Tuesday should be the business day following Monday')
    assert_equal(monday_2017_06_12 + 4, test_chore.add_business_days(start_date: monday_2017_06_12, work_days: 4), 'Friday should be four business days after Monday')
    assert_equal(monday_2017_06_12 + 7, test_chore.add_business_days(start_date: monday_2017_06_12, work_days: 5), 'Five business days after Monday should be the following Monday')
    assert_equal(monday_2017_06_12 + 7, test_chore.add_business_days(start_date: monday_2017_06_12 + 4, work_days: 1), 'Monday should be one business day after Friday')
    assert_equal(monday_2017_06_12 + 7, test_chore.add_business_days(start_date: monday_2017_06_12 + 5, work_days: 1), 'Monday should be one business day after Saturday')
    assert_equal(monday_2017_06_12 + 7, test_chore.add_business_days(start_date: monday_2017_06_12 + 6, work_days: 1), 'Monday should be one business day after Sunday')
    assert_equal(monday_2017_06_12 + 7, test_chore.add_business_days(start_date: monday_2017_06_12 + 1, work_days: 4), 'Monday should be four business days after Tuesday')
    assert_equal(monday_2017_06_12 + (52 * 7), test_chore.add_business_days(start_date: monday_2017_06_12, work_days: (52 * 5)), '52 weeks should be the same as calendar or busesiness days')
    assert_not_equal(monday_2017_06_12 + 5, test_chore.add_business_days(start_date: monday_2017_06_12, work_days: 5), 'Saturday is not a business day')
    assert_not_equal(monday_2017_06_12 + 6, test_chore.add_business_days(start_date: monday_2017_06_12, work_days: 6), 'Sunday is not a business day')
  end
  test 'add_business_days translates negative numbers into positive' do
    assert_equal(monday_2017_06_12 + 1, test_chore.add_business_days(start_date: monday_2017_06_12, work_days: -1), 'Negative one is the same as positive one day for add_business_days')
    assert_equal(monday_2017_06_12 + 15, test_chore.add_business_days(start_date: monday_2017_06_12, work_days: -11), 'Negative eleven business days is two weeks and a day in the future')
  end
  test 'add_business_days translates zero into one' do
    assert_equal(monday_2017_06_12, test_chore.add_business_days(start_date: monday_2017_06_12, work_days: 0), 'Zero returns the next business day from one calendar day ago')
    assert_equal(monday_2017_06_12 + 7, test_chore.add_business_days(start_date: monday_2017_06_12 + 5, work_days: 0), 'Zero returns the next business day from one calendar day ago')
  end
  test 'add_business_days ignores fractional parts of work_days' do
    assert_equal(monday_2017_06_12 + 7, test_chore.add_business_days(start_date: monday_2017_06_12, work_days: -5.98765), 'decimals should be truncated after taking the absolue value')
  end
  test 'add_business_days translates Time and DateTime into Date' do
    assert_equal(monday_2017_06_12 + 1, test_chore.add_business_days(start_date: Time.parse('June 12 01:03 +1100 2017'), work_days: 1), 'Time should be converted to the local Date')
    assert_equal(monday_2017_06_12 + 1, test_chore.add_business_days(start_date: DateTime.parse('June 12 01:03 +1100 2017'), work_days: 1), 'DateTime should be converted to the local Date')
  end

  # HACK: remove the over-kill tests of the future and past. Get it down to one positive and one negative.
  # HACK: group negative tests with the positive ones.
  # HACK: add negative tests where a given result is NOT returned when some other input is provided.

  test 'due_class nil condition' do
    assert_equal('not-due', test_chore.due_class(nil), 'A blank due_date should be not-due')
  end

  test 'due_class due later' do
    (7..20).each do |n|
      assert_equal('due-later', test_chore.due_class(Date.today + n), "#{n} days in the future should be due later than this week")
    end
    (1..10).each do |n|
      days = n ** 2 * 365
      assert_equal('due-later', test_chore.due_class(Date.today + days + 1), "When due in the far future (#{days + 1} days) it should be due later than this week")
      assert_equal('due-later', test_chore.due_class(Date.today + days), "When due in the far future (#{days} days) it should be due later than this week")
      assert_equal('due-later', test_chore.due_class(Date.today + days - 1), "When due in the far future (#{days - 1} days) it should be due later than this week")
    end
  end

  test 'due_class due this week' do
    (1..6).each do |n|
      assert_equal('due-week', test_chore.due_class(Date.today + n), "#{n} days in the future should be due this week, but not today")
    end
  end

  test 'due_class due today' do
    assert_equal('due-today', test_chore.due_class(Date.today), 'Today should be due-today')
  end

  test 'due_class overdue' do
    (-10..-1).each do |n|
      assert_equal('overdue', test_chore.due_class(Date.today + n), "When due in the past (#{0 - n} days) it should be overdue")
    end
    (1..10).each do |n|
      days = n ** 2 * 365
      assert_equal('overdue', test_chore.due_class(Date.today - (days + 1)), "When due in the past (#{days + 1} days) it should be overdue")
      assert_equal('overdue', test_chore.due_class(Date.today - days), "When due in the past (#{days} days) it should be overdue")
      assert_equal('overdue', test_chore.due_class(Date.today - (days - 1)), "When due in the past (#{days - 1} days) it should be overdue")
    end
  end

  test 'due_class fail on time' do
    assert_raises(ArgumentError) do
      test_chore.due_class(Time.now)
    end
    assert_raises(ArgumentError) do
      test_chore.due_class(DateTime.now)
    end
  end

  test 'due_class fail on string' do
    assert_raises(ArgumentError) do
      test_chore.due_class('2017-07-31')
    end
  end

  test 'due_class fail on boolean' do
    assert_raises(ArgumentError) do
      test_chore.due_class(true)
    end
    assert_raises(ArgumentError) do
      test_chore.due_class(false)
    end
  end

  test 'due_class fail on numbers' do
    assert_raises(ArgumentError) do
      test_chore.due_class(12345)
    end
    assert_raises(ArgumentError) do
      test_chore.due_class(-12345)
    end
    assert_raises(ArgumentError) do
      test_chore.due_class(0)
    end
    assert_raises(ArgumentError) do
      test_chore.due_class(1.2345)
    end
  end

  test 'five calendar day interval' do
    test_chore = Chore.new(interval_days: 5)
    assert(test_chore.calendar_days_interval_type?, 'Default is calendar_days')
    assert_equal(5, test_chore.interval_days, 'Five day interval')
    assert_nil(test_chore.last_done, 'Unset last done')
    assert_nil(test_chore.cycle_reset, 'Unset cycle date')
    assert_nil(test_chore.next_due, 'Unset due date')
    assert(test_chore.reset_cycle_date, 'expect success')
    assert_equal(Date.today, test_chore.last_done, 'done today')
    assert_in_delta(Time.now, test_chore.cycle_reset, 30, 'cycled just now')

    assert_equal(Date.today + 5, test_chore.next_due, 'due in five')
  end

  test 'five business day interval' do
    test_chore = Chore.new(interval_days: 5, interval_type: 'business_days')
    assert(test_chore.business_days_interval_type?, 'Explicitly set to business days')
    assert_equal(5, test_chore.interval_days, 'Five day interval')
    assert_nil(test_chore.last_done, 'Unset last done')
    assert_nil(test_chore.cycle_reset, 'Unset cycle date')
    assert_nil(test_chore.next_due, 'Unset due date')
    assert(test_chore.reset_cycle_date, 'expect success')
    assert_equal(Date.today, test_chore.last_done, 'done today')
    assert_in_delta(Time.now, test_chore.cycle_reset, 30, 'cycled just now')

    assert_equal(Date.today + 7, test_chore.next_due, 'due in five business days')
  end

  test 'all interval types are handled' do
    test_chore = Chore.new(interval_days: 20)

    Chore.interval_types.keys.each do |type|
      test_chore.interval_type = type
      assert(test_chore.reset_cycle_date, 'Each interval_type should be handled')
    end
  end
end
