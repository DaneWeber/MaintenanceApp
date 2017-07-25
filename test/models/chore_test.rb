require 'test_helper'

class ChoreTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test 'due_class calculations' do
    # it 'should be not-due when there is no due date' do
      # Arrange
      test_chore = Chore.new
      # Act
      # case
      # when next_due == nil
      #   'not-due'
      # when next_due < Date.today
      #   'overdue'
      # when next_due < Date.today + 1
      #   'due-today'
      # when next_due < Date.today + 7
      #   'due-week'
      # else
      #   'due-later'
      # end

      # Assert
      assert_equal('not-due',   test_chore.due_class(nil),             'A blank due_date should be not-due')
      assert_equal('due-later', test_chore.due_class(Date.today + 10), 'Ten days in the future should be due-later')
      assert_equal('due-later', test_chore.due_class(Date.today + 9),  'Nine days in the future should be due-later')
      assert_equal('due-later', test_chore.due_class(Date.today + 8),  'Eight days in the future should be due-later')
      assert_equal('due-later', test_chore.due_class(Date.today + 7),  'Seven days in the future should be due-later')
      assert_equal('due-week',  test_chore.due_class(Date.today + 6),  'Six days in the future should be due-week')
      assert_equal('due-week',  test_chore.due_class(Date.today + 5),  'Five days in the future should be due-week')
      assert_equal('due-week',  test_chore.due_class(Date.today + 4),  'Four days in the future should be due-week')
      assert_equal('due-week',  test_chore.due_class(Date.today + 3),  'Three days in the future should be due-week')
      assert_equal('due-week',  test_chore.due_class(Date.today + 2),  'Two days in the future should be due-week')
      assert_equal('due-week',  test_chore.due_class(Date.today + 1),  'One day in the future should be due-week')
      assert_equal('due-today', test_chore.due_class(Date.today + 0),  'Today should be due-today')
      assert_equal('overdue',   test_chore.due_class(Date.today - 1),  'One day in the future should be overdue')
      assert_equal('overdue',   test_chore.due_class(Date.today - 2),  'Two days in the future should be overdue')
      assert_equal('overdue',   test_chore.due_class(Date.today - 3),  'Three days in the future should be overdue')
      assert_equal('overdue',   test_chore.due_class(Date.today - 4),  'Four days in the future should be overdue')
      assert_equal('overdue',   test_chore.due_class(Date.today - 5),  'Five days in the future should be overdue')
    # end
  end
end
