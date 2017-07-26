require 'test_helper'

class ChoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'due_class calculations' do
    # Arrange
    test_chore = Chore.new

    # Act

    # Assert
    assert_equal('not-due',   test_chore.due_class(nil),             'A blank due_date should be not-due')

    (7..20).each do |n|
      assert_equal('due-later', test_chore.due_class(Date.today + n), "#{n} days in the future should be due later than this week.")
    end

    (1..6).each do |n|
      assert_equal('due-week', test_chore.due_class(Date.today + n), "#{n} days in the future should be due this week, but not today.")
    end

    assert_equal('due-today', test_chore.due_class(Date.today),  'Today should be due-today')

    (-10..-1).each do |n|
      assert_equal('overdue', test_chore.due_class(Date.today + n), "When due in the past (#{0 - n} days) it should be overdue")
    end
  end
end
