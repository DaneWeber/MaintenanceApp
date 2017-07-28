require 'test_helper'

class ChoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # Arrange
  test_chore = Chore.new

  # Act

  # Assert
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
end
