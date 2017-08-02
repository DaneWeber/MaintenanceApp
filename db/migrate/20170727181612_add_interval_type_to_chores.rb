class AddIntervalTypeToChores < ActiveRecord::Migration[5.1]
  def change
    add_column :chores, :interval_type, :integer, default: 0
  end
end
