class AddCycleResetToChores < ActiveRecord::Migration[5.1]
  def change
    add_column :chores, :cycle_reset, :datetime
  end
end
