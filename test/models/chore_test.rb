require 'test_helper'

class ChoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # Arrange
  t_chore = Chore.new

  # Act

  # Assert
  test 'add_business_days' do
    monday = Date.parse('2017-06-12')
    assert_equal(monday, t_chore.add_business_days(start_date: monday, work_days: 0), 'Same business day')
    assert_equal(monday + 4, t_chore.add_business_days(start_date: monday, work_days: 4), 'Friday should be four business days after Monday')
    assert_equal(monday + 7, t_chore.add_business_days(start_date: monday, work_days: 5), 'Monday should be five business days after Monday')
    assert_equal(monday + 7, t_chore.add_business_days(start_date: monday + 4, work_days: 1), 'Monday should be one business days after Friday')
    assert_raises(ArgumentError) do
      t_chore.add_business_days(start_date: monday, work_days: -1)
    end
  end

  # HACK: remove the over-kill tests of the future and past. Get it down to one positive and one negative.
  # HACK: group negative tests with the positive ones.
  # HACK: add negative tests where a given result is NOT returned when some other input is provided.

  test 'due_class nil condition' do
    assert_equal('not-due', t_chore.due_class(nil), 'A blank due_date should be not-due')
  end

  test 'due_class due later' do
    (7..20).each do |n|
      assert_equal('due-later', t_chore.due_class(Date.today + n), "#{n} days in the future should be due later than this week")
    end
    (1..10).each do |n|
      days = n ** 2 * 365
      assert_equal('due-later', t_chore.due_class(Date.today + days + 1), "When due in the far future (#{days + 1} days) it should be due later than this week")
      assert_equal('due-later', t_chore.due_class(Date.today + days), "When due in the far future (#{days} days) it should be due later than this week")
      assert_equal('due-later', t_chore.due_class(Date.today + days - 1), "When due in the far future (#{days - 1} days) it should be due later than this week")
    end
  end

  test 'due_class due this week' do
    (1..6).each do |n|
      assert_equal('due-week', t_chore.due_class(Date.today + n), "#{n} days in the future should be due this week, but not today")
    end
  end

  test 'due_class due today' do
    assert_equal('due-today', t_chore.due_class(Date.today), 'Today should be due-today')
  end

  test 'due_class overdue' do
    (-10..-1).each do |n|
      assert_equal('overdue', t_chore.due_class(Date.today + n), "When due in the past (#{0 - n} days) it should be overdue")
    end
    (1..10).each do |n|
      days = n ** 2 * 365
      assert_equal('overdue', t_chore.due_class(Date.today - (days + 1)), "When due in the past (#{days + 1} days) it should be overdue")
      assert_equal('overdue', t_chore.due_class(Date.today - days), "When due in the past (#{days} days) it should be overdue")
      assert_equal('overdue', t_chore.due_class(Date.today - (days - 1)), "When due in the past (#{days - 1} days) it should be overdue")
    end
  end

  test 'due_class fail on time' do
    assert_raises(ArgumentError) do
      t_chore.due_class(Time.now)
    end
    assert_raises(ArgumentError) do
      t_chore.due_class(DateTime.now)
    end
  end

  test 'due_class fail on string' do
    assert_raises(ArgumentError) do
      t_chore.due_class('2017-07-31')
    end
  end

  test 'due_class fail on boolean' do
    assert_raises(ArgumentError) do
      t_chore.due_class(true)
    end
    assert_raises(ArgumentError) do
      t_chore.due_class(false)
    end
  end

  test 'due_class fail on numbers' do
    assert_raises(ArgumentError) do
      t_chore.due_class(12345)
    end
    assert_raises(ArgumentError) do
      t_chore.due_class(-12345)
    end
    assert_raises(ArgumentError) do
      t_chore.due_class(0)
    end
    assert_raises(ArgumentError) do
      t_chore.due_class(1.2345)
    end
  end

  test 'five day interval' do
    t_chore = Chore.new(interval_days: 5)
    assert_equal(5, t_chore.interval_days, 'Five day interval')
    assert_nil(t_chore.last_done, 'Unset last done')
    assert_nil(t_chore.cycle_reset, 'Unset cycle date')
    assert_nil(t_chore.next_due, 'Unset due date')
    assert(t_chore.reset_cycle_date, 'expect success')
    assert_equal(Date.today, t_chore.last_done, 'done today')
    assert_in_delta(Time.now, t_chore.cycle_reset, 30, 'cycled just now')
    assert_equal(Date.today + 5, t_chore.next_due, 'due in five')
  end
end
